FROM ubuntu:focal-20210416

# texlive-jaインストールガイド
# https://www.tug.org/texlive/doc/texlive-ja/texlive-ja.pdf

# texlive.profileは./install-tlで生成可

ARG LTX_VERSION="2021"
ARG LTX_PROFILE="full"
# texlive.profile.TEXDIRに合わせること
ARG LTX_PATH="/usr/local/texlive/${LTX_VERSION}"

WORKDIR /tex

ADD profiles/${LTX_PROFILE}.profile ./texlive.profile 

RUN \
    apt-get update -y \
    # avoid intaractive tz selection during apt-get 
    && apt-get install -y --no-install-recommends tzdata \
    && apt-get install -y --no-install-recommends locales \
        && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
        && echo "ja_JP.UTF-8" >> /etc/locale.gen \
        && locale-gen \
    && apt-get install -y --no-install-recommends \
        curl perl wget gosu \
    && curl -sLO http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz \
        && tar xzf install-tl-unx.tar.gz \
        # fix year of texlive.profile
        && sed -i -E "s/20[0-9]{2}/${LTX_VERSION}/g" texlive.profile \
        # test downloaded version
        && test `cat ./install-tl-*/release-texlive.txt | head -n1 | sed -E 's/^.*version (20[0-9]{2})$/\1/'` -eq ${LTX_VERSION} \
        && ./install-tl-*/install-tl --profile texlive.profile \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf *

ENV PATH=$PATH:${LTX_PATH}/bin/x86_64-linux \
    MANPATH=$MANPATH:${LTX_PATH}/texmf-dist/doc/man \
    INFOPATH=$INFOPATH:${LTX_PATH}/texmf-dist/doc/info

RUN tlmgr install \
        collection-fontsrecommended \
        collection-langcjk \
        collection-langjapanese \
        latexmk

ADD entrypoint.sh /entrypoint.sh
RUN chmod 700 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
