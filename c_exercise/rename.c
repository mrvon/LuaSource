/*
Backing up Redis data

Before starting this section, make sure to read the following sentence: Make
Sure to Backup Your Database. Disks break, instances in the cloud disappear, and
so forth: no backups means huge risk of data disappearing into /dev/null. Redis
is very data backup friendly since you can copy RDB files while the database is
running: the RDB is never modified once produced, and while it gets produced it
uses a temporary name and is renamed into its final destination atomically using
rename(2) only when the new snapshot is complete.

This means that copying the RDB file is completely safe while the server is
running. This is what we suggest:

Create a cron job in your server creating hourly snapshots of the RDB
file in one directory, and daily snapshots in a different directory.

Every time the cron script runs, make sure to call the find command to make sure
too old snapshots are deleted: for instance you can take hourly snapshots for
the latest 48 hours, and daily snapshots for one or two months. Make sure to
name the snapshots with data and time information.

At least one time every day make sure to transfer an RDB snapshot outside your
data center or at least outside the physical machine running your Redis
instance.

This code show how redis use rename function to replace old rdb file with new
one safely when user have open old one.
*/

#include <stdio.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
    const char* ori_name = "origin.rdb";
    const char* tmp_name = "temp.rdb";

    int fd = 0;
    char buf[64];

    /* Open origin file before rename it. */
    fd = open(ori_name, O_RDONLY);

    if (fd == -1) {
        perror("Open origin file.");
        return 0;
    }

    if (rename(tmp_name, ori_name) == -1) {
        perror("Rename.");
        return 0;
    }

    /*
     * Here, file temp have been rename as origin,
     * But we can read old origin file via fd.
     */

    /* Read origin file after rename is safe */
    while (1) {
        int n = read(fd, buf, sizeof(buf));
        if (n == -1) {
            perror("Read file.");
            break;
        }

        if (n == 0) {
            break;
        }

        /* fprintf(stdout, "\nRead %d bytes.\n", n); */

        n = write(STDOUT_FILENO, buf, n);
        if (n == -1) {
            perror("Write file.");
            break;
        }
    }

    /*
     * Open origin file again.
     */
    fd = open(ori_name, O_RDONLY);

    while (1) {
        int n = read(fd, buf, sizeof(buf));
        if (n == -1) {
            perror("Read file.");
            break;
        }

        if (n == 0) {
            break;
        }

        /* fprintf(stdout, "\nRead %d bytes.\n", n); */

        n = write(STDOUT_FILENO, buf, n);
        if (n == -1) {
            perror("Write file.");
            break;
        }
    }

    return 0;
}
