import requests

url = "https://www.baidu.com/s?ie=utf-8&newi=1&mod=1&isid=nobdidobdid95570&wd=asda%20asdasdasd&rsv_spt=1&rsv_iqid=0x9d7569a3000f5559&issp=1&f=8&rsv_bp=1&rsv_idx=2&ie=utf-8&tn=baiduhome_pg&rsv_dl=ib&rsv_enter=1&rsv_sug3=14&rsv_sug1=6&rsv_sug7=101&rsv_sid=62325_63142_63324_63560_63724_63728_63275_63778_63804_63837_63881_63889_63904_63934_63949_63948_63957_63990&_ss=1&clist=&hsug=&csor=14&pstg=5&_cr1=28943"
cookies = {
    "bce-sessionid": "0015356cd74e8f240bf89b8f2fa4a778a0c",
    "BDUSS": "GFmMjJGRVZ-cUMzU2JCZWgyMlhHU1JxaUFETmRJcXpnVE9ZUXVGSkNzSzNYa05uRUFBQUFBJCQAAAAAAAAAAAEAAAAu57Ao2K3U9cO0xNy5uwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALfRG2e30RtnN",
    "BDUSS_BFESS": "GFmMjJGRVZ-cUMzU2JCZWgyMlhHU1JxaUFETmRJcXpnVE9ZUXVGSkNzSzNYa05uRUFBQUFBJCQAAAAAAAAAAAEAAAAu57Ao2K3U9cO0xNy5uwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALfRG2e30RtnN",
    "BDSFRCVID": "MP-OJeC62ZMCufjJOb7oEHtYogbAts7TH6aoA55Hv61Bt-6-LFPaEG0PRf8g0KuhQaccogKK0mOTHv81d2L2no4C8phfUEhNffCctf8g0x5",
    "H_BDCLCKID_SF": "tbP8_IDbtK_3qn7I5KI5j68LhltX5-RLfbRpKq7F5l8-hxc52R7xXn3-5lQQKR3h-2oR5KTv3COxOKQphURDb47bD-5h3Mcb-2owafoN3KJmMJL9bT3vLfu9jfJz2-biWbRL2MbdQRvP_IoG2Mn8M4bb3qOpBtQmJeTxoUJ25DnJhbLGe6-Ke5v-eaLqqbbfb-ojXn_5HJOoDDvNbxbcy4LdjG5Hyb0O3gOJVxTsKJ5Me4O8KU7cD4LH3-Aq54RX-e_LVl3k3-3ih-LwK6u-QfbQ0MbuqP-jW2caXPTLan7JOpkxhfnxyhLfQRPH-Rv92DQMVU52QqcqEIQHQT3m5-5bbN3Ot6IttbFHoIIbtIvVetbpKPP_-P6M5qriWMT-0bFH_hbwyC85OCOhBnrpyb04hPrx2nbqJan7_f783nrjJq5u3-n6-PDmXfONJUQxtNRN0Dnjtpvhj-jVKtbobUPUDN59LUkqWKnb04K-Bbc8eInCMqQ5hT50W-bQLb3hfIkjXIKLJCP2bKtGj5A3hn88hmTKaCrLa573L6rJKKvCshOOy4oTj6jWDq0HafTZta6dhp5dbUToOq315nDb3MvBBUTDJ5Ja0Kc-hJcqafbmHfo8Qft20MtEeMtjBbQ3Bm5mKR7jWhk5hl72y5jvb-085H59atTMfTc0b4OOJD5iEnR55-DWbT8bjHCttj_qJJKfVIvbabQMK4Tv5JQhh6oH-UIsWl8LB2Q-5KL-yq6TfJQFyxnDjP4kyhOk2-ba06ne_MbdJJjoEDKGybD-DfD3qHDLWU5TKmTxoUJ45DnJhhvGMhQH-PtebPRiJPr9QgbqVIjetq4KDRAmLT72M-KAQf7wKt5mK5nhVn0MMIK0HPonHj_5j6vb3H",
    "H_WISE_SIDS_BFESS": "61027_60853_61362_61694_61736_61781_61791_61824_61845_61862_61901",
    "sugstore": "1",
    "BAIDUID_BFESS": "3F2295D7998F9C710BBD2D64C95F12E9:FG=1",
    "BDSFRCVID_BFESS": "MP-OJeC62ZMCufjJOb7oEHtYogbAts7TH6aoA55Hv61Bt-6-LFPaEG0PRf8g0KuhQaccogKK0mOTHv81d2L2no4C8phfUEhNffCctf8g0x5",
    "H_BDCLCKID_SF_BFESS": "tbP8_IDbtK_3qn7I5KI5j68LhltX5-RLfbRpKq7F5l8-hxc52R7xXn3-5lQQKR3h-2oR5KTv3COxOKQphURDb47bD-5h3Mcb-2owafoN3KJmMJL9bT3vLfu9jfJz2-biWbRL2MbdQRvP_IoG2Mn8M4bb3qOpBtQmJeTxoUJ25DnJhbLGe6-Ke5v-eaLqqbbfb-ojXn_5HJOoDDvNbxbcy4LdjG5Hyb0O3gOJVxTsKJ5Me4O8KU7cD4LH3-Aq54RX-e_LVl3k3-3ih-LwK6u-QfbQ0MbuqP-jW2caXPTLan7JOpkxhfnxyhLfQRPH-Rv92DQMVU52QqcqEIQHQT3m5-5bbN3Ot6IttbFHoIIbtIvVetbpKPP_-P6M5qriWMT-0bFH_hbwyC85OCOhBnrpyb04hPrx2nbqJan7_f783nrjJq5u3-n6-PDmXfONJUQxtNRN0Dnjtpvhj-jVKtbobUPUDN59LUkqWKnb04K-Bbc8eInCMqQ5hT50W-bQLb3hfIkjXIKLJCP2bKtGj5A3hn88hmTKaCrLa573L6rJKKvCshOOy4oTj6jWDq0HafTZta6dhp5dbUToOq315nDb3MvBBUTDJ5Ja0Kc-hJcqafbmHfo8Qft20MtEeMtjBbQ3Bm5mKR7jWhk5hl72y5jvb-085H59atTMfTc0b4OOJD5iEnR55-DWbT8bjHCttj_qJJKfVIvbabQMK4Tv5JQhh6oH-UIsWl8LB2Q-5KL-yq6TfJQFyxnDjP4kyhOk2-ba06ne_MbdJJjoEDKGybD-DfD3qHDLWU5TKmTxoUJ45DnJhhvGMhQH-PtebPRiJPr9QgbqVIjetq4KDRAmLT72M-KAQf7wKt5mK5nhVn0MMIK0HPonHj_5j6vb3H",
    "H_WISE_SIDS": "61027_62325_62967_63142_63194_63161_63211_63243_63247_63253_63324_63357_63364",
    "ZFY": "pb7MrXNWph:ABMXEXgOUrgi3xf07rwxZJ3wweFSOfXns:C",
    "__bid_n": "1974b540cd8977638847a0",
    "PSTM": "1751984740",
    "BD_UPN": "12314753",
    "BIDUPSID": "41326F3203A39AEBCB5EB5A9B6F5D911",
    "ab_sr": "1.0.1_YmM4ZTBmMGQ0MmRiMDJiNmE2ZjE5M2JkOWY1OTA0MWZlMTc5OTdiMWU1NGRmYzVlZGYxMjFiMGExOTNlMmUwMTMyNWEzZTQ0ODVhYmZhYWMxYTZmZDljY2Y3Y2VjNzUwYzgyOTNkMzc4MjFkMWE5MzUzMjE0YzFkZmNlMzVjMThiYTU1YTNlODNkOTEwMDlkZDM2OTkwMDgzN2UxMWM0Mg==",
    "RT": "\"z=1&dm=baidu.com&si=7f33257f-634d-4b88-96c2-cea3e8ccc4ec&ss=mcx13hou&sl=1&tt=bau&bcn=https%3A%2F%2Ffclog.baidu.com%2Flog%2Fweirwood%3Ftype%3Dperf&ld=coi\"",
    "H_PS_PSSID": "62325_63142_63324_63560_63724_63728_63275_63778_63804_63837_63881_63889_63904_63934_63949_63948_63957_63990",
    "BA_HECTOR": "2ga42g8k8g20a5002g8g0k008h8kai1k6urpr25",
    "BDRCVFR[feWj1Vr5u3D]": "I67x6TjHwwYf0",
    "BD_CK_SAM": "1",
    "PSINO": "7",
    "delPer": "0",
    "BDSVRTM": "36",
}

headers = {
    "Host": "www.baidu.com",
    "Connection": "keep-alive",
    "Pragma": "no-cache",
    "Cache-Control": "no-cache",
    "sec-ch-ua-platform": "\"Windows\"",
    "is_referer": "https://www.baidu.com/",
    "Ps-Dataurlconfigqid": "0x9d7569a3000f5559",
    "sec-ch-ua": "\"Not)A;Brand\";v=\"8\", \"Chromium\";v=\"138\", \"Google Chrome\";v=\"138\"",
    "is_params": "imes=0.3.102211.0.3.180",
    "sec-ch-ua-mobile": "?0",
    "is_xhr": "1",
    "X-Requested-With": "XMLHttpRequest",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36",
    "Accept": "*/*",
    "Sec-Fetch-Site": "same-origin",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Dest": "empty",
    "Referer": "https://www.baidu.com/",
    "Accept-Encoding": "gzip, deflate, br, zstd",
    "Accept-Language": "en,zh-CN;q=0.9,zh;q=0.8"
}

res = requests.get(url, headers=headers, cookies=cookies)
print(res.text)
