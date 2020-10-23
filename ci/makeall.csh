# Search for rtl/ folders and execute make from the found rtl folder
find . -type d -name rtl \( -execdir test -f rtl/makefile \; -printf "Building %p ...\n" -execdir make -C rtl \; \)
