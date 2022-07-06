# manifest-aws
Current manifest for the service running on AWS for practable.io

This repo contains the latest version of the manifest for the live service, and the scripts required to upload it to the booking server. 

## Pre-requisites

These scripts are intended for use on linux systems. Windows is not not currently supported. MacOS may work (untested).

### practable/relay/book

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

### JQ

See [installation instructions](https://linuxhint.com/bash_jq_command/) for `jq`, which we use to read and print jwt tokens and dates in the booking status.

## Authorization

The scripts require a credential to work. This credential is not contained in the repo, because it is private to the admin team.

To supply the credential to the scripts, create a directory `secret` in your repo, and put the booking secret into `./secret/book.pat`

If you get this correct, then the script will run fine. Else, you will receive this message

```
cat: ./secret/book.pat: No such file or directory
export BOOK_SECRET before running script
```

Do not remove the entry `secret/` from `.gitignore`, because this will allow the secret to be included in the repo.


## Editing 

Make changes to the manifest, and compare to previous known-good version using `git diff`

## testing

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
0. issue `s` and check the `last_booking_ends` date/time. Obviously there are no relevant bookings running on our test server, but this shows the approach.
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

You will now see what is being uploaded - the order may vary and contents be different depending on the manifest at the time

```
Definitely upload [y/N]?y
INFO[0000] Pool of   1: Spinner (72g)                   
INFO[0000] Pool of   2: Spinner (Develop B)             
INFO[0000] Pool of   1: Spinner 2.0 (#11)               
INFO[0000] Pool of   1: Penduino 00                     
INFO[0000] Pool of   1: Camera-test-E                   
INFO[0000] Pool of   1: Penduino 05                     
INFO[0000] Pool of   1: Penduino 14                     
INFO[0000] Pool of   2: Spinner (Develop F)             
INFO[0000] Pool of   1: Spinner 2.0 (#03)               
INFO[0000] Pool of   1: Spinner 2.0 (#08)               
INFO[0000] Pool of   1: Camera-test-A                   
INFO[0000] Pool of   3: Spinner (129g)                  
INFO[0000] Pool of   0: Spinner (Everyone)              
INFO[0000] Pool of   2: Turner (Everyone)               
INFO[0000] Pool of   1: PVNA 01                         
INFO[0000] Pool of   2: Spinner (Develop I)             
INFO[0000] Pool of   2: Spinner (Develop J)             
INFO[0000] Pool of   1: Spinner 2.0 (#05)               
INFO[0000] Pool of   1: Spinner 2.0 (#09)               
INFO[0000] Pool of   1: Camera-test-B                   
INFO[0000] Pool of   1: Penduino 01                     
INFO[0000] Pool of   1: Penduino 09                     
INFO[0000] Pool of   1: Penduino 11                     
INFO[0000] Pool of   1: Penduino 18                     
INFO[0000] Pool of   1: Penduino 19                     
INFO[0000] Pool of 100: Spinner (Simulated)             
INFO[0000] Pool of   1: Spinner (29g)                   
INFO[0000] Pool of   1: Odroid test                     
INFO[0000] Pool of   1: Spinner (100g)                  
INFO[0000] Pool of   1: Penduino 06                     
INFO[0000] Pool of   0: Spinner (114g)                  
INFO[0000] Pool of   2: Turner (Develop A)              
INFO[0000] Pool of   1: Camera-test-C                   
INFO[0000] Pool of   2: Spinner (62g metal disk)        
INFO[0000] Pool of   0: Spinner (Controls 3)            
INFO[0000] Pool of   1: Spinner (43g)                   
INFO[0000] Pool of   1: Spinner 2.0 (#10)               
INFO[0000] Pool of   1: Spinner (49g metal disk)        
INFO[0000] Pool of   1: Penduino 12                     
INFO[0000] Pool of   1: Spinner (105g metal disk)       
INFO[0000] Pool of   2: Spinner (Develop C)             
INFO[0000] Pool of   1: Penduino 02                     
INFO[0000] Pool of   1: Penduino 07                     
INFO[0000] Pool of   1: PVNA 00                         
INFO[0000] Pool of   1: Spinner (49g metal disk)        
INFO[0000] Pool of   1: Spinner 2.0 (#07)               
INFO[0000] Pool of   1: Turner (Develop C)              
INFO[0000] Pool of   1: Penduino 03                     
INFO[0000] Pool of   1: PVNA 04                         
INFO[0000] Pool of   1: Spinner 2.0 (#01)               
INFO[0000] Pool of   2: Turner (Develop B)              
INFO[0000] Pool of   1: Penduino 16                     
INFO[0000] Pool of   1: Penduino 15                     
INFO[0000] Pool of   1: Penduino 17                     
INFO[0000] Pool of   2: Spinner (110g metal disk)       
INFO[0000] Pool of   2: Spinner (86g)                   
INFO[0000] Pool of   1: Spinner 2.0 (#00)               
INFO[0000] Pool of   0: Turner (Develop)                
INFO[0000] Pool of   0: Turner (Develop D)              
INFO[0000] Pool of   1: Penduino 04                     
INFO[0000] Pool of   1: Penduino 10                     
INFO[0000] Pool of   1: PVNA 03                         
INFO[0000] Pool of   1: Spinner (43g metal disk)        
INFO[0000] Pool of   1: Spinner (85g metal disk)        
INFO[0000] Pool of   1: Spinner (Develop)               
INFO[0000] Pool of   2: Spinner (Develop G)             
INFO[0000] Pool of   1: Spinner 2.0 (#02)               
INFO[0000] Pool of  17: Penduinos                       
INFO[0000] Pool of   1: Spinner 2.0 (#04)               
INFO[0000] Pool of   1: Spinner (57g)                   
INFO[0000] Pool of   1: Penduino 08                     
INFO[0000] Pool of   1: Penduino 13                     
INFO[0000] Pool of   1: PVNA 02                         
INFO[0000] Pool of   2: Spinner (57g metal disk)        
INFO[0000] Pool of  11: Spinner (Develop A)             
INFO[0000] Pool of   1: Spinner (Develop E)             
INFO[0000] Pool of   1: Spinner (Develop H)             
INFO[0000] Pool of   2: Turner (Controls 3)             
INFO[0000] Pool of   1: Camera-test-H                   
INFO[0000] Pool of   1: Truss (Large)                   
INFO[0000] Pool of   1: Camera-test-D                   
INFO[0000] Pool of   1: Camera-test-G                   
INFO[0000] Pool of   1: Spinner (85g metal disk - modified) 
INFO[0000] Pool of   2: Spinner (Develop D)             
INFO[0000] Pool of   1: Spinner 2.0 (#06)               
INFO[0000] Pool of   1: Camera-test-F                   
Group: spinnerv2 
  -   1x Spinner 2.0 (#00)
  -   1x Spinner 2.0 (#01)
  -   1x Spinner 2.0 (#02)
  -   1x Spinner 2.0 (#03)
  -   1x Spinner 2.0 (#04)
  -   1x Spinner 2.0 (#05)
  -   1x Spinner 2.0 (#06)
  -   1x Spinner 2.0 (#07)
Group: controls3 
  -   1x Spinner (43g metal disk)
  -   1x Spinner (49g metal disk)
  -   2x Spinner (57g metal disk)
  -   2x Spinner (62g metal disk)
  -   1x Spinner (85g metal disk)
  -   1x Spinner (105g metal disk)
  -   2x Spinner (110g metal disk)
  - 100x Spinner (Simulated)
Group: everyone 
  - 100x Spinner (Simulated)
  -  17x Penduinos
Group: test 
  -   1x Penduino 00
  -   1x Penduino 01
  -   1x Penduino 02
  -   1x Penduino 03
  -   1x Penduino 04
  -   1x Penduino 05
  -   1x Penduino 06
  -   1x Penduino 07
  -   1x Penduino 08
  -   1x Penduino 09
  -   1x Penduino 10
  -   1x Penduino 11
  -   1x Penduino 12
  -   1x Penduino 13
  -   1x Penduino 14
  -   1x Penduino 15
  -   1x Penduino 16
  -   1x Penduino 17
  -   1x Penduino 18
  -   1x Penduino 19
Group: truss 
  -   1x Truss (Large)
Group: emag3 
  -   1x PVNA 00
  -   1x PVNA 01
  -   1x PVNA 02
  -   1x PVNA 03
  -   1x PVNA 04
Group: develop 
  -   1x Odroid test
  -   1x Spinner (Develop)
  -   1x Spinner (49g metal disk)
  -   1x Spinner (85g metal disk - modified)
  -   1x Camera-test-A
  -   1x Camera-test-B
  -   1x Camera-test-C
  -   1x Camera-test-D
  -   1x Camera-test-E
  -   1x Camera-test-F
  -   1x Camera-test-G
  -   1x Camera-test-H
Group: spinner-develop 
  -   1x Spinner (49g metal disk)
Group: spinnerv2-dev 
  -   1x Spinner 2.0 (#08)
  -   1x Spinner 2.0 (#09)
  -   1x Spinner 2.0 (#10)
  -   1x Spinner 2.0 (#11)
Group: camera-test 
  -   1x Camera-test-A
  -   1x Camera-test-B
  -   1x Camera-test-C
  -   1x Camera-test-D
  -   1x Camera-test-E
  -   1x Camera-test-F
  -   1x Camera-test-G
  -   1x Camera-test-H
Group: pendulum-test 
  -  17x Penduinos
  -   1x Penduino 00
  -   1x Penduino 01
  -   1x Penduino 02
  -   1x Penduino 03
  -   1x Penduino 04
  -   1x Penduino 05
  -   1x Penduino 06
  -   1x Penduino 07
  -   1x Penduino 08
  -   1x Penduino 09
  -   1x Penduino 10
  -   1x Penduino 11
  -   1x Penduino 12
  -   1x Penduino 13
  -   1x Penduino 14
  -   1x Penduino 15
  -   1x Penduino 16
  -   1x Penduino 17
  -   1x Penduino 18
  -   1x Penduino 19
Group: pendulum-maintenance 
  -   1x Penduino 01
  -   1x Penduino 07
  -   1x Penduino 08
  -   1x Penduino 09
  -   1x Penduino 13
  -   1x Penduino 15
  -   1x Penduino 17
{
	"activities": 223,
	"groups": 12,
	"last_booking_ends": 1657100824,
	"msg": "Open for bookings",
	"pools": 86
}
```
0. If you have a local version of the booking app, you can point it at the booking app running in the test script (see information at the start of the test script, note that the port number xxxxx is randomly assigned and varies from run to run)

```
book server at localhost:xxxxx (testing)
```
0. Now you can reset `r`, and check status `s`, and see that the status returns to:
```
{
	"last_booking_ends": 1657101048,
	"msg": "Open for bookings"
}
```
0. Now you can upload again, and see that the status changes to 
```
<snip>
{
	"activities": 223,
	"groups": 12,
	"last_booking_ends": 1657100824,
	"msg": "Open for bookings",
	"pools": 86
}
```
0. Stop the test server with Ctrl-C

Note - if the test fails for any reason, or throws a seg-fault, then the manifest is missing a reference to one of the objects used to build the data structure. Judicious use of git diff should see you right for now.

## Upload

Current operating procedure is to 
0. run `serve.sh`
0. issue `s` and check the `last_booking_ends` date/time. if there are no current bookings, then proceed (ok to proceed if the latest booking is your own and you can see there are no other bookings in the system - that is out of scope for this repo though). If there date is more than 1 minute into the future, then it is a human booking, else it is just a spinner demo booking. You can ignore the spinner demo bookings for this purpose.
0. open the booking page for the group you are modifying, e.g. [everyone](https://book.practable.io) and check it is alright, before you start.
0. use `r` to delete all existing manifest entries, confirm with `yes`
0. use `u` to upload your (tested) manifest, confirm with `y`
0. check the [booking system](https://book.practable.io) to see it it showing what you expect.






