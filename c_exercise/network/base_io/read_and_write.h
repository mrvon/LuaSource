#ifndef __READ_AND_WRITE__
#define __READ_AND_WRITE__

#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

int ReadBuf(int fd, char* buf, int len)
{
    // Return -1 stand for error 
    // Return 0  stand for EOF
    // Other is positive nature number, stand for length of read

    if(fd == -1)
    {
        return -1;
    }

    if(buf == NULL)
    {
        return -1;
    }

    ssize_t ret = 0;
    size_t  real_read_len = 0;

    while(len != 0 && (ret = read(fd, buf, len)) != 0)
    {
        if(ret == -1)
        {
            if(errno == EINTR)
            {
                continue;
            }
            perror("read");
            break;
        }

        len -= ret;
        buf += ret;
        real_read_len += ret;
    }

    return real_read_len;
}

int ReadBufNonblocking(int fd, char* buf, int len)
{
    if(fd == -1)        
    {
        return -1;
    }

    if(buf == NULL)
    {
        return -1;
    }

    ssize_t number_of_read = 0;
    int     real_read_len = 0;

start:
    number_of_read = read(fd, buf, len);
    if(number_of_read == -1)
    {
        if(errno == EINTR)
        {
            goto start; // on shush
        }
        else if(errno == EAGAIN)
        {
            // resubmit later
            printf("EAGAIN\n");
            sleep(2);
            goto start;
        }
        else
        {
            perror("Other Error");
            return -1;
        }
    }
    else if(number_of_read == 0)
    {
        // EOF
        return real_read_len;
    }
    else
    {
        buf += number_of_read;
        len -= number_of_read;
        real_read_len += number_of_read;
        goto start; 
    }

    return real_read_len;
}

int WriteBuf(int fd, const char* buf, int len)
{
    if(fd == -1) 
    {
        return -1;
    }

    if(buf == NULL)
    {
        return -1;
    }

    int real_write_len = 0;
    int number_of_write = 0;

    while(len != 0 && (number_of_write = write(fd, buf, len)) != 0)
    {
        if(number_of_write == -1)
        {
            if(errno == EINTR)
            {
                continue;
            }
            perror("write");
            break;
        }

        len -= number_of_write;
        buf += number_of_write;
        real_write_len += number_of_write;
    }

    return real_write_len;
}

int WriteBufNonblocking(int fd, const char* buf, int len)
{
    if(fd == -1)
    {
        return -1;
    }

    if(buf == NULL)
    {
        return -1;
    }

    int real_write_len = 0;
    int number_of_write = 0;

start:
    number_of_write = write(fd, buf, len);
    if(number_of_write == -1)
    {
        if(errno == EINTR)
        {
            goto start;
        }
        else if(errno == EAGAIN) 
        {
            printf("EAGAIN\n");
            sleep(2);   // write 2 minute
            goto start;
        }
        else
        {
            perror("Other Error");
            return -1;
        }
    }
    else
    {
        len -= number_of_write;
        buf += number_of_write;
        real_write_len += number_of_write;

        if(len > 0)
        {
            goto start;
        }
    }

    return real_write_len;
}




#endif
