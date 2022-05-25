# thrash-script
A script to repeatedly write to a disk for a stress test

## Notes

To create a source file, use something like:

```
dd if=/dev/random of=~/thrash/thrash-source bs=1024 count=262144
```

The `count` should equal the number of MB you want multiplied by 1024.
