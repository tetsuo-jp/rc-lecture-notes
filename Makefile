# 電子情報工学演習 セミナー資料のビルド
# 和文クラス（jsarticle）なので platex -> dvipdfmx を使う。pdflatex では通らない。
TEX = platex -interaction=nonstopmode
DVI = dvipdfmx -q
VER = v1.0
DOCS = rc01_pebbling_rate rc02_erasure_pebbling rc03_resource_atlas

.PHONY: all clean sums stamp upgrade
all: $(DOCS:%=pdf/%.stamp)

pdf/%.stamp: src/%.tex
	cd src && $(TEX) $*.tex >/dev/null && $(TEX) $*.tex >/dev/null && $(DVI) $*.dvi
	@case $* in \
	  rc01_*) n=rc01;; rc02_*) n=rc02;; rc03_*) n=rc03;; esac; \
	  cp src/$*.pdf pdf/$$n-$(VER).pdf
	@touch $@

sums:
	cd pdf && sha256sum *.pdf > ../SHA256SUMS && cat ../SHA256SUMS

clean:
	cd src && rm -f *.aux *.log *.dvi *.out *.toc *.pdf

# 時刻証明（OpenTimestamps）。OTS = ots クライアントの場所
OTS = $(HOME)/.venvs/ots/bin/ots

stamp: SHA256SUMS
	$(OTS) stamp SHA256SUMS
	@echo "押印した。数時間後に make upgrade を実行し、確定した .ots をコミットすること。"

upgrade:
	$(OTS) upgrade SHA256SUMS.ots
	$(OTS) verify SHA256SUMS.ots
