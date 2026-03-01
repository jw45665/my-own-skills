#!/usr/bin/env python3
"""
Environment Detector Skill
==========================
Ermittelt automatisch Umgebungsinformationen für das model-metadata.json environment-Objekt.

Usage:
    python detect_env.py --output data/env-detected.json
    python detect_env.py --merge data/model-metadata.json
"""

import json
import os
import platform
import subprocess
import sys
from datetime import datetime
from pathlib import Path
import argparse


def detect_os():
    """Ermittle Betriebssystem mit Details."""
    system = platform.system()
    release = platform.release()
    version = platform.version()
    
    if system == "Windows":
        return f"Windows {release}"
    elif system == "Darwin":
        return f"macOS {release}"
    elif system == "Linux":
        # Versuche Distribution zu ermitteln
        try:
            with open("/etc/os-release") as f:
                lines = f.readlines()
                for line in lines:
                    if line.startswith("PRETTY_NAME"):
                        return line.split("=")[1].strip().strip('"')
        except:
            pass
        return f"Linux {release}"
    else:
        return f"{system} {release}"


def detect_node_version():
    """Ermittle Node.js Version wenn verfügbar."""
    try:
        result = subprocess.run(
            ["node", "--version"],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except:
        pass
    return None


def detect_python_version():
    """Ermittle Python Version."""
    return f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"


def detect_vscode_info():
    """Versuche VS Code Informationen zu ermitteln."""
    vscode_info = {
        "ide": None,
        "ide_version": None,
        "extensions": [],
        "detected_method": None
    }
    
    # Methode 1: VS Code CLI
    try:
        result = subprocess.run(
            ["code", "--version"],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            lines = result.stdout.strip().split('\n')
            if len(lines) >= 1:
                vscode_info["ide_version"] = lines[0]
                vscode_info["detected_method"] = "code --version"
    except:
        pass
    
    # Methode 2: Extensions auflisten
    try:
        result = subprocess.run(
            ["code", "--list-extensions", "--show-versions"],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode == 0:
            extensions = result.stdout.strip().split('\n')
            # Filtere relevante Extensions
            relevant = ["copilot", "github", "python", "pylance", "playwright"]
            vscode_info["extensions"] = [
                ext for ext in extensions 
                if any(r in ext.lower() for r in relevant)
            ]
    except:
        pass
    
    # IDE-Name: Heuristik
    if vscode_info["ide_version"]:
        # Standard-Annahme
        vscode_info["ide"] = "Visual Studio Code (detected)"
        vscode_info["ide_confidence"] = "medium"
    
    return vscode_info


def detect_mcp_servers():
    """Versuche MCP Server aus VS Code Settings zu lesen."""
    mcp_servers = []
    
    # Prüfe verschiedene Config-Orte
    possible_configs = []
    
    # User Settings (Windows)
    if platform.system() == "Windows":
        appdata = os.getenv("APPDATA")
        if appdata:
            possible_configs.append(
                Path(appdata) / "Code" / "User" / "settings.json"
            )
    
    # User Settings (macOS/Linux)
    else:
        home = Path.home()
        possible_configs.extend([
            home / ".config" / "Code" / "User" / "settings.json",
            home / "Library" / "Application Support" / "Code" / "User" / "settings.json"
        ])
    
    # Workspace Settings
    workspace_settings = Path.cwd() / ".vscode" / "settings.json"
    if workspace_settings.exists():
        possible_configs.insert(0, workspace_settings)
    
    # Parse Settings
    for config_path in possible_configs:
        if not config_path.exists():
            continue
        
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                # Entferne Kommentare (einfache Variante)
                content = f.read()
                lines = [line.split('//')[0] for line in content.split('\n')]
                cleaned = '\n'.join(lines)
                
                settings = json.loads(cleaned)
                
                # Suche nach MCP-Config
                if "mcp" in settings or "mcpServers" in settings:
                    mcp_config = settings.get("mcp", settings.get("mcpServers", {}))
                    if isinstance(mcp_config, dict):
                        mcp_servers.extend(mcp_config.keys())
                
        except Exception as e:
            print(f"Info: Konnte {config_path} nicht lesen: {e}", file=sys.stderr)
            continue
    
    return list(set(mcp_servers))  # Deduplizieren


def detect_copilot_version():
    """Versuche GitHub Copilot Version zu ermitteln."""
    try:
        result = subprocess.run(
            ["code", "--list-extensions", "--show-versions"],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode == 0:
            for line in result.stdout.strip().split('\n'):
                if "github.copilot@" in line.lower():
                    return line.split('@')[1] if '@' in line else None
    except:
        pass
    return None


def generate_environment_object():
    """Generiere vollständiges Environment-Objekt."""
    vscode_info = detect_vscode_info()
    mcp_servers = detect_mcp_servers()
    copilot_version = detect_copilot_version()
    
    env = {
        "ide": vscode_info["ide"] or "Visual Studio Code (please verify)",
        "ide_version": vscode_info["ide_version"] or "<PLEASE_DETECT_MANUALLY>",
        "copilot_version": copilot_version or "<PLEASE_DETECT_MANUALLY>",
        "extensions": vscode_info["extensions"] or [
            "GitHub Copilot (detected automatically if possible)"
        ],
        "mcp_servers": mcp_servers or [
            "playwright",
            "microsoft-docs",
            "github"
        ],
        "test_date": datetime.now().strftime("%Y-%m-%d"),
        "os": detect_os(),
        "python_version": detect_python_version(),
        "node_version": detect_node_version(),
        "notes": "",
        "_detection_metadata": {
            "auto_detected": vscode_info["detected_method"] is not None,
            "confidence": vscode_info.get("ide_confidence", "low"),
            "manual_verification_needed": [
                field for field, value in {
                    "ide": vscode_info["ide"],
                    "ide_version": vscode_info["ide_version"],
                    "copilot_version": copilot_version
                }.items() if value is None or "<PLEASE" in str(value)
            ]
        }
    }
    
    return env


def merge_into_metadata(metadata_path, env_data):
    """Füge Environment-Daten in existierende model-metadata.json ein."""
    with open(metadata_path, 'r', encoding='utf-8') as f:
        metadata = json.load(f)
    
    # Merge environment, behalte manuelle Einträge bei
    if "environment" in metadata:
        # Update nur fehlende Felder
        for key, value in env_data.items():
            if key not in metadata["environment"] or not metadata["environment"][key]:
                metadata["environment"][key] = value
    else:
        metadata["environment"] = env_data
    
    # Schreibe zurück
    with open(metadata_path, 'w', encoding='utf-8') as f:
        json.dump(metadata, f, indent=4, ensure_ascii=False)
    
    print(f"✅ Environment-Daten in {metadata_path} aktualisiert")
    
    # Zeige Felder, die manuelle Verifikation brauchen
    manual_fields = env_data.get("_detection_metadata", {}).get("manual_verification_needed", [])
    if manual_fields:
        print(f"\n⚠️  Bitte manuell prüfen: {', '.join(manual_fields)}")


def main():
    parser = argparse.ArgumentParser(
        description="Ermittle Umgebungsinformationen für model-metadata.json"
    )
    parser.add_argument(
        "--output",
        help="Speichere erkannte Daten als separate JSON-Datei"
    )
    parser.add_argument(
        "--merge",
        help="Merge erkannte Daten in existierende model-metadata.json"
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Zeige detaillierte Erkennungsinformationen"
    )
    
    args = parser.parse_args()
    
    # Erkenne Environment
    env_data = generate_environment_object()
    
    if args.verbose:
        print("🔍 Erkannte Umgebungsinformationen:")
        print(json.dumps(env_data, indent=2, ensure_ascii=False))
        print()
    
    # Output Modus
    if args.output:
        output_path = Path(args.output)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(env_data, f, indent=4, ensure_ascii=False)
        
        print(f"✅ Environment-Daten gespeichert: {output_path}")
    
    # Merge Modus
    elif args.merge:
        merge_into_metadata(args.merge, env_data)
    
    # Default: Print to stdout
    else:
        print(json.dumps(env_data, indent=2, ensure_ascii=False))
    
    # Hinweise für manuelle Schritte
    metadata = env_data.get("_detection_metadata", {})
    if not metadata.get("auto_detected"):
        print("\n💡 Tipp: Führe 'code --version' manuell aus, um IDE-Version zu ermitteln")
    
    if metadata.get("manual_verification_needed"):
        print(f"\n⚠️  Manuelle Verifikation empfohlen für: {', '.join(metadata['manual_verification_needed'])}")
        print("   IDE-Name kann meist nicht automatisch erkannt werden.")
        print("   Bitte trage ein: 'Visual Studio Code', 'Visual Studio', 'Cursor', etc.")


if __name__ == "__main__":
    main()
