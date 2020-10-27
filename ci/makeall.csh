# Search for rtl/ folders containing a makefile
find . -type d -name rtl \( -execdir test -f rtl/makefile \; -print0 \) > folderlist

echo "Starting building projects" | tee build.log

# Invoke make for each of rtl/makefile files found
xargs -a folderlist -0 -n 1 -t make -C  # 1>>build.log

echo "Completed building projects" | tee -a build.log
