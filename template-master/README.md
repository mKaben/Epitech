# PDF Generator

## Usage

Generate the PDF from a markdown file

```

docker pull epitechcontent/subject_template
docker run --rm -v $(pwd):/pdf -u $(id -u):$(id -g) epitechcontent/subject_template tuto/example.md
```

The PDF file will be generated next to the markdown file

```
ls -l tuto/example.pdf
```

## Alias

In your .bashrc:

```sh
function epitech_generate_pdf () {
    docker run --rm -v $(pwd):/pdf -u $(id -u):$(id -g) epitechcontent/subject_template $@
}
```

Then:

```
epitech_generate_pdf bootstrap.md
```

## Build

Build the docker image that will be used to generate the PDF

```
docker build -t epitechcontent/subject_template .
docker push epitechcontent/subject_template:latest
```
