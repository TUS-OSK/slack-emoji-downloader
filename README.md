# Slack Emoji Downloader

Slackのカスタム絵文字をダウンロードするやつ

## Usage

```
env SLACK_API_TOKEN='****' bundle exec ruby main.rb
```

`/emoji`にダウンロードされる

ついでに名前とURLのデータも`/emoji/emoji.json`に吐く
