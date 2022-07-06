# manifest-aws
Current manifest for the service running on AWS for practable.io

This repo contains the latest version of the manifest for the live service, and the scripts required to upload it to the booking server. 

## Authorization

The scripts require a credential to work. This credential is not contained in the repo, because it is private to the admin team.

To supply the credential to the scripts, create a directory `secret` in your repo, and put the booking secret into `./secret/book.pat`

If you get this correct, then the script will run fine. Else, you will receive this message

```
cat: ./secret/book.pat: No such file or directory
export BOOK_SECRET before running script
```

Do not remove the entry `secret/` from `.gitignore`, because this will allow the secret to be included in the repo.


## Testing

Make changes to the manifest, and compare to previous known-good version using `git diff`

You can test your new manifest by uploading to the test server (this is created at the start of the `test_serve.sh` script)

## Upload

Current operating procedure is to 

0. run `serve.sh`
0. issue `s` and copy the datetime
0. in a separate terminal, `date -d @xxxxx` where xxxx is the datetime (remember the `@`!)
0. if there are no current bookings, then proceed (ok to proceed if the latest booking is your own and you can see there are no other bookings in the system - that is out of scope for this repo though)
0. use `r` to delete all existing manifest entries, confirm with `yes`
0. use `u` to upload your (tested) manifest, confirm with `y`
0. check the [booking system](https://book.practable.io) to see it it showing what you expect.






