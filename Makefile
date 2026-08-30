# 電子情報工学演習 セミナー資料のビルド
# 和文クラス（jsarticle）なので platex -> dvipdfmx を使う。pdflatex では通らない。
TEX = platex -interaction=nonstopmode
DVI = dvipdfmx -q
VER = v1.0
DOCS = rc01_pebbling_rate rc02_erasure_pebbling rc03_resource_atlas

.PHONY: all clean sums
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
