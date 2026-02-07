///@desc avoid memory leaks

if (path_exists(my_path)) {
    path_delete(my_path);
}