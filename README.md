ubuntuベースのtexliveイメージ

## build
以下の変数が定義されています。必要に応じてオーバーライドして下さい。

|variable|description|
|:--|:--|
|LTX_VERSION|TeX Liveのバージョン|
|LTX_PROFILE|インストールプロファイル名|

```
$ docker build --build-arg LTX_PROFILE=basic -t ulatex --no-cache .
```

## latexk
コンパイルを自動で行うlatexmkがインストールされます。
以下は`platex`+`dvipdfmx`を使用した場合の `.latexmkrc`の一例です。

```
#!/usr/bin/perl

# %O: option
# %S: source file

# -halt-on-errorは引数の順番に注意
$latex     = 'platex -halt-on-error -interaction=nonstopmode %O %S';
$dvipdf    = 'dvipdfmx %O -o %D %S';
$pdf_mode  = '3'; # .tex -> .dvi -> .pdf

# viewerを起動しない
$pdf_previewer = ''
```

## latex-workshop in container
`.devcontainer/devcotainer.json`
```
{
    "dockerComposeFile": "./docker-compose.yml",
    "remoteUser": "user",
    "service": "tex",
    "workspaceFolder": "/tex",
    "extensions": [
        "james-yu.latex-workshop",
        "streetsidesoftware.code-spell-checker"
    ]
}
```

`.devcontainer/docker-compose.json`
```
version: "3"
services:
  tex:
    image: face0u0/ulatex
    tty: true
    volumes:
      - ..:/tex
    environment:
      - USER_ID=1000
      - GROUP_ID=1000
    command: >
      bash -c "
        bash
      "
```

## latex-workshop on host
vscodeのlatex-workshopで使用するには`.vscode/settings.json`に以下を追記して下さい。

```
{
    "latex-workshop.docker.enabled": true,
    "latex-workshop.docker.image.latex": "face0u0/ulatex",
    "latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
             "-e",
             "$latex     = 'platex -halt-on-error -interaction=nonstopmode %O %S'",
             "-e",
             "$dvipdf    = 'dvipdfmx %O -o %D %S'",
             "%DOC%"
            ]
        }
    ]
}
```
