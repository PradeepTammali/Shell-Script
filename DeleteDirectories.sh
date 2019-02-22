Directory Structure

2012-12-12
2012-10-12
2012-08-08
How would I delete the directories that are older than 10 days with a bash shell script?

This will do it recursively for you:

find  /path/to/base/dir/*  -type  d  -ctime +10 -exec rm -rf {} \;


Explanation:
    find: the unix command for finding files / directories / links etc.
    /path/to/base/dir: the directory to start your search in.
    -type d: only find directories
    -ctime +10: only consider the ones with modification time older than 10 days
    -exec ... \;: for each such result found, do the following command in ...
    rm -rf {}: recursively force remove the directory; the {} part is where the find result gets substituted into from the previous part.


Alternatively, use:
    find /path/to/base/dir/* -type d -ctime +10 | xargs rm -rf
    Which is a bit more efficient, because it amounts to:
    rm -rf dir1 dir2 dir3 ...
    as opposed to:
    rm -rf dir1; rm -rf dir2; rm -rf dir3; ...
    as in the -exec method.

Note:
    With modern versions of find you can replace the ; with + and it will do the equivalent of the xargscall for you, passing as many files as will fit on each exec system call: find . -type d -ctime +10 -exec rm -rf {} +