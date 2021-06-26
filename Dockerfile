FROM ubuntu:focal-20210416

# texlive-jaインストールガイド
# https://www.tug.org/texlive/doc/texlive-ja/texlive-ja.pdf

# texlive.profileは./install-tlで生成することも可能
ARG LTX_VERSION="2021"
ARG LTX_PROFILE="basic"

WORKDIR /tex

ADD profiles/${LTX_PROFILE}.profile ./texlive.profile 

RUN \
    apt-get update -y \
    # apt-get中のTZ選択を避ける
    && apt-get install -y --no-install-recommends tzdata \
    && apt-get install -y --no-install-recommends locales \
        && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
        && echo "ja_JP.UTF-8" >> /etc/locale.gen \
        && locale-gen \
    && apt-get install -y --no-install-recommends \
        curl perl wget \
    && curl -sLO http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz \
        && tar xzf install-tl-unx.tar.gz \
        # texlive.profileの年度を修正
        && sed -i -E "s/20[0-9]{2}/${LTX_VERSION}/g" texlive.profile \
        && ./install-tl-${LTX_VERSION}*/install-tl --profile texlive.profile \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf * 

ENV PATH $PATH:/usr/local/texlive/${LTX_VERSION}/bin/x86_64-linux
ENV MANPATH $MANPATH:/usr/local/texlive/${LTX_VERSION}/texmf-dist/doc/man
ENV INFOPATH $INFOPATH:/usr/local/texlive/${LTX_VERSION}/texmf-dist/doc/info

RUN tlmgr install \
        collection-fontsrecommended \
        collection-langcjk \
        collection-langjapanese \
        latexmk
