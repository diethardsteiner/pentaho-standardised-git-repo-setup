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
madoko -v ./pcm2017.md --odir=/home/dsteiner/Documents/pcm2017-presentation-html
```

Settings used for HTML output (have to be put at the beginning of document):

```
[INCLUDE=presentation]
Title         : Pentaho Standardised Git Repo Setup
Sub Title     : For Big Agile Teams
Author        : Diethard Steiner
Affiliation   : Bissol Consulting Ltd
Email         : diethard.steiner@bissolconsulting.com
Reveal Theme  : night
Beamer Theme  : metropolis

[TITLE]
```


To generate a PDF version run:

```
madoko --pdf -vv ./pcm2017.md --odir=/home/dsteiner/Documents/pcm2017-presentation-pdf
```


Settings used for PDF output (have to be put at the beginning of document):

```
Title         : Pentaho Standardised Git Repo Setup
Sub Title     : For Big Agile Teams
Author        : Diethard Steiner
Affiliation   : Bissol Consulting Ltd
Email         : diethard.steiner@bissolconsulting.com

[TITLE]

[TOC]
```

# Fix code block font color for the HTML output

Add to main HTML (at the same time we also change the color of the bold text):

```
code {
  color: #349cd5;
}
.strong-star2{
  color:burlywood;  
}
```

Quick hack to add the logo:

```
body {
    background-image: url("/home/dsteiner/git/pentaho-standardised-git-repo-setup/presentations/pics/logo_v4_white_small.png") !important;
    background-repeat: no-repeat !important;
    background-size:initial !important;
}
```

