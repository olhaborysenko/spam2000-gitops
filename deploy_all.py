#!/usr/bin/env python3
"""
Deploy all Kubernetes manifests for Spam2000 GitOps Platform with a single command.
- Applies all YAMLs in namespaces/ and apps/
- Prints pod status for key namespaces
"""
import subprocess
import sys
from pathlib import Path

NAMESPACES = ["monitoring", "spam2000", "argocd"]


def run(cmd: str) -> None:
    """Run a shell command, print it, and exit on failure."""
    print(f"\033[1;34m$ {cmd}\033[0m")
    try:
        subprocess.run(cmd, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"\033[1;31mCommand failed: {cmd}\033[0m")
        sys.exit(e.returncode)


def apply_manifests(directory: Path) -> None:
    """Apply all YAML manifests in a directory."""
    for file in sorted(directory.glob("*.yml")) + sorted(directory.glob("*.yaml")):
        run(f"kubectl apply -f {file}")


def main() -> None:
    root = Path(__file__).parent
    print("\n\033[1;32mApplying namespaces...\033[0m")
    apply_manifests(root / "namespaces")
    print("\n\033[1;32mApplying apps...\033[0m")
    apply_manifests(root / "apps")
    print("\n\033[1;32mAll manifests applied!\033[0m")
    for ns in NAMESPACES:
        print(f"\nPods in namespace {ns}:")
        run(f"kubectl get pods -n {ns}")


if __name__ == "__main__":
    main()
