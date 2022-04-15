#!/bin/bash

add_files() {

  [[ $* ]] || return

  [[ -d $_template_dir ]] || {
    ERM "bashbud: creating new template: $_template_dir"
    mkdir -p "$_template_dir"
  }

  target_dir=$(realpath "$PWD")

  for file; do
    ERT "$file"
    [[ -f $file || -d $file ]] || continue
    file_to_add=$(readlink -f "$file")
    target_file="${file_to_add/$target_dir/$_template_dir}"
    mkdir -p "${target_file%/*}"
    cp -r "$_cp_flag" "$file" "$target_file"
  done
}
