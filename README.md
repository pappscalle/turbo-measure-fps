# dos-template

A simple Turbo Pascal program used as a template.
Target computer: 286-12MHz

Uses external tpu files, added via "git submodule"
They will reside in `src/external/src/units`

Create a new repo from the template and then clone the new repo with `--recurse-submodules` e.g:
```
git clone --recurse-submodules git@github.com:pappscalle/my-cloned-repo.git

```

If the submodule is not downloaded:
```
git submodule update --init --recursive
```
