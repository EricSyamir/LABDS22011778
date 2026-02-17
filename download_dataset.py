import kagglehub
import os
import shutil


def main() -> None:
    # Download latest version of the dataset
    path = kagglehub.dataset_download("georgeokullo/uncleaned-dataset")
    print("Path to dataset files:", path)

    # Create target folder inside the repo
    target = os.path.join(os.getcwd(), "Lab Project 1")
    os.makedirs(target, exist_ok=True)

    # Copy all contents from the downloaded path into Lab Project 1
    for name in os.listdir(path):
        src = os.path.join(path, name)
        dst = os.path.join(target, name)

        if os.path.isdir(src):
            if os.path.exists(dst):
                shutil.rmtree(dst)
            shutil.copytree(src, dst)
        else:
            shutil.copy2(src, dst)

    print("Copied dataset into:", target)


if __name__ == "__main__":
    main()

