# How to run the presentation

[Source](http://madoko.org/reference.html)
[Madoko Online Editor](https://www.madoko.net/editor.html)

To install Madoko locally:

```
npm install madoko -g
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
  color: darkgray;
}
```
