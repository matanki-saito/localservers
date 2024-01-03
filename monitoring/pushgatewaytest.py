import textwrap

import requests


def push():
    data = textwrap.dedent('''
        # TYPE hoge_metrics gauge
        # HELP hoge_metrics
        hoge_metrics 1.0
        ''')  # 最終行に改行を入れないと400が返るので注意
    res = post(data)


def post(data):
    headers = {'Content-Type': 'application/x-www-form-urlencoded'}
    res = requests.post(
        "http://localhost:52581/metrics/job/metrics/job/TEST_JOB/host_name/TEST_HOST/ENVIRONMENT/TEST_LOCATION",
        headers=headers, data=data)
    if res.status_code != 200:
        raise Exception("failed : {}".format(res.status_code))
    return res


# https://qiita.com/noexpect/items/630ecda5895cfc411900
if __name__ == '__main__':
    push()
