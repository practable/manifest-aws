# manifest-aws
Current manifest for the service running on AWS for practable.io

This repo contains the latest version of the manifest for the live service, and the scripts required to upload it to the booking server. 

## Pre-requisites

Build the `book` command from [relay](https://github.com/practable/relay.git) and put on your path, e.g. `/usr/local/bin`

```
git clone https://github.com/practable/relay.git
cd relay/cmd/book
go build
sudo cp book /usr/local/bin
```

check it exists:
```
$ book
Book provides commands for a booking server and client, including 
managing instant-access bookings for equipment, uploading bookings, resetting
the booking server, getting the booking server status, and generating new
tokens to access the booking server.

Usage:
  book [command]

Available Commands:
  completion  Generate the autocompletion script for the specified shell
  getstatus   Get the lock status and message of the day
  help        Help about any command
  reset       Delete all activities, pools and groups in the booking server.
  serve       Start the booking server
  setstatus   Set the lock status and message of the day
  token       session token generates a new token for authenticating to book
  upload      Upload a manifest of activities, pools and groups to booking server

Flags:
      --config string   config file (default is $HOME/.book.yaml)
  -h, --help            help for book
  -t, --toggle          Help message for toggle

Use "book [command] --help" for more information about a command.
```


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

```
$ ./test_serve.sh
Admin token:
ey....
2022/07/06 10:42:18 Serving booking at http://[::]:49152
User token:
ey....
{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "groups": [
    "everyone",
    "controls3",
    "develop"
  ],
  "scopes": [
    "login:user"
  ],
  "pools": [],
  "aud": [
    "localhost"
  ],
  "exp": 1657186937,
  "nbf": 1657100537,
  "iat": 1657100537
}
BOOKJS_USERTOKEN=ey...
BOOKRESET_HOST=localhost:49152
BOOKRESET_SCHEME=http
BOOKSTATUS_HOST=localhost:49152
BOOKSTATUS_SCHEME=http
BOOKSTATUS_TOKEN=ey...
BOOKTOKEN_ADMIN=false
BOOKTOKEN_AUDIENCE=localhost
BOOKTOKEN_GROUPS='everyone controls3 develop'
BOOKTOKEN_LIFETIME=86400
BOOKTOKEN_SECRET=testing
BOOKUPLOAD_HOST=localhost:49152
BOOKUPLOAD_SCHEME=http
BOOKUPLOAD_TOKEN=ey...
BOOK_FQDN=localhost
BOOK_LOGINTIME=3600
BOOK_PORT=49152
BOOK_SECRET=testing
_=BOOKSTATUS_TOKEN=ey...
book server at localhost:49152 (testing)
commands:
  g: start insecure chrome
  l: Lock bookings
  n: uNlock bookings
  r: reset the poolstore (has confirm)
  s: get the status of the poolstore)
  t: serve the everyone token on port 4001
  u: re-upload manifest
What next? [l/n/r/s/t/u]:
```
Practice run
0. issue `s` and copy the datetime from the status message
```
{
	"last_booking_ends": 1657100538,
	"msg": "Open for bookings"
}
```
0. in a separate terminal, `date -d @xxxxx` where xxxx is the datetime (remember the `@`!)

```
$ date -d @1657100538
Wed  6 Jul 10:42:18 BST 2022
```
0. Obviously there are no relevant bookings running on our test server, but this shows the approach.
0. use `r` to delete all existing manifest entries, confirm with `yes`, then check the status
You will now see 
```
reset complete
What next? [l/n/r/s/t/u]:s
{
	"last_booking_ends": 1657100683,
	"msg": "Open for bookings"
}
```
This empty status message shows the manifest has been emptied out as required.

0. use `u` to upload your (tested) manifest, confirm with `y`

0. check the [booking system](https://book.practable.io) to see it it showing what you expect.


## Upload

Current operating procedure is to 

0. run `serve.sh`
0. issue `s` and copy the datetime
0. in a separate terminal, `date -d @xxxxx` where xxxx is the datetime (remember the `@`!)
0. if there are no current bookings, then proceed (ok to proceed if the latest booking is your own and you can see there are no other bookings in the system - that is out of scope for this repo though)
0. use `r` to delete all existing manifest entries, confirm with `yes`
0. use `u` to upload your (tested) manifest, confirm with `y`
0. check the [booking system](https://book.practable.io) to see it it showing what you expect.






