#! /usr/bin/python3

import argparse
import os
import subprocess


def update_module(module):
    cwd = os.getcwd()
    print("Updating module[{}]".format(module))

    os.chdir(module)
    output = subprocess.check_output(["git", "checkout", "master"])
    print("\tChecking out to master...\n\t\t[{}]".format(output))

    output = subprocess.check_output(["git", "pull", "origin", "master"])
    print("\tPulling from master...\n\t\t[{}]".format(output))

    os.chdir(cwd)


def update_directory(directory):
    files = [f for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f))]
    files = [os.path.join(directory, f) for f in files if f.endswith(".gitmodules")]
    if len(files) == 0:
        return
    if len(files) > 1:
        raise ValueError()
    gitmodule_file = files[0]
    modules = []
    with open(gitmodule_file, 'r') as f:
        lines = f.readlines()
        lines = [l for l in lines if "path =" in l]
        for l in lines:
            tokens = l.strip().split(" = ")
            if len(tokens) != 2:
                raise ValueError()
            modules.append(tokens[1])

    output = subprocess.check_output(["git", "submodule", "init"])
    print("Initializing submodules... \n\t[{}]".format(output))

    output = subprocess.check_output(["git", "submodule", "update", "--init", "--recursive"])
    print("Initializing submodules recursively... \n\t[{}]".format(output))
    print()

    for module in modules:
        module_dir = os.path.join(directory, module)
        update_directory(module_dir)
        update_module(module_dir)



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-dir", type=str, default="")
    args = parser.parse_args()

    if args.dir == "":
        args.dir = os.getcwd()

    update_directory(args.dir)
