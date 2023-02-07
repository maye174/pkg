import os
import shutil

def copy_json_files(src_dir, dest_dir):
    """Copy all JSON files in src_dir and its subdirectories to dest_dir"""
    for dir_path, dir_names, file_names in os.walk(src_dir):
        for file_name in file_names:
            if file_name.endswith('.json'):
                src_file = os.path.join(dir_path, file_name)
                relative_dir = os.path.relpath(dir_path, src_dir)
                dest_file = os.path.join(dest_dir, relative_dir, file_name)

                # Create the destination directory if it doesn't exist
                os.makedirs(os.path.dirname(dest_file), exist_ok=True)

                # Copy the file
                shutil.copy2(src_file, dest_file)

def categorize_json_files(root_dir):
    """Categorize JSON files based on the given rule and store them in subdirectories"""
    for dir_path, dir_names, file_names in os.walk(root_dir):
        for file_name in file_names:
            if file_name.endswith('.json'):
                # Extract the first letter of the filename
                first_letter = file_name[0].lower()

                # Create subdirectory based on the first letter
                sub_dir = os.path.join(dir_path, first_letter)
                if not os.path.exists(sub_dir):
                    os.makedirs(sub_dir)

                # Move the JSON file to the subdirectory
                file_path = os.path.join(dir_path, file_name)
                new_file_path = os.path.join(sub_dir, file_name)
                os.rename(file_path, new_file_path)

pkg_main_dir = '../pkg/Main/bucket'
pkg_extras_dir = '../pkg/Extras/bucket'
dest_dir = '.'
copy_json_files(pkg_main_dir, dest_dir)
copy_json_files(pkg_extras_dir, dest_dir)

#categorize_json_files(dest_dir)