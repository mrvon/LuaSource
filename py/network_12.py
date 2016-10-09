import ntplib
from time import ctime


def print_time():
    ntp_client = ntplib.NTPClient()
    responce = ntp_client.request('pool.ntp.org')
    print('Current time: {}'.format(responce.delay))
    print('Delay time: {}'.format(ctime(responce.tx_time)))


if __name__ == '__main__':
    print_time()
