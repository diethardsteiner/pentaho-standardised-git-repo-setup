# How to run the presentation

[Source](http://madoko.org/reference.html)
[Madoko Online Editor](https://www.madoko.net/editor.html)

To install Madoko locally:

```
npm install madoko -g
```

Install Latex support: Recommended is to use [TexLive](https://www.tug.org/texlive/)
Install instructions can be found [here](https://www.tug.org/texlive/quickinstall.html)

```
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
gunzip -k install-tl-unx.tar.gz
tar -xvf install-tl-unx.tar
cd install-tl-20170921
sudo ./install-tl
```

Use the `I` option when asked to install this.

Finally, make the binaries available system wide:

```
export PATH=$PATH:/usr/local/texlive/2017/bin/x86_64-linux
```



To get the HTML output run:

```
madoko -v ./pcm2107.md --odir=/home/dsteiner/Documents/pcm2017-presentatation-html
```


To generate a PDF version run:

```
madoko --pdf -vv ./pcm2107.md --odir=/home/dsteiner/Documents/pcm2017-presentatation-pdf
```

# Fix code block font color

Add to main HTML:

```
code {
  color: #349cd5;
}
```
