NOTICE
======

This project is now deprecated (sadly, deprecated even before anything can be released from it. :/) however a newer, better and simpler installment is set up and is under active development. We kept it secret for a while and now it is open to all of you. Please redirect your energies to <https://github.com/xcvista/WebFusion>. Thanks.

FusionKit
=========

This is the WebFusion SDK for iOS\Macs and other apple stuff. It's now version 3, the version 1 and 2 is deprecated due to server server scheme upgrade. 

Shisoft WebFusion is a experimental project for the people whose hair is set on fire because of the information overload. Our goal is help to make the internet much easier, users can get what they want from only one platform instead of search and wandering. WebFusion now is at MARK I, it provides primary data collecting and display, messenger and content search.You can now use WebFusion to pay attention for your friends or news feeds from about 30 webservices.You can also use WebFusion as instant messenger or a mail box for private conversation. The MARK II will provide recommendation system. It will learn who you are, what you are interested and what are you expecting to learn form the the internet. The system will give you some advise when you finding friends or searching contents. We are still planning MARK III.

This SDK is brought to you by xcvista, Jack Shi as project founder, supervisor and serve-side developer.

* WebFusion does not use any practical authorize mechanism. Client can get access to the user private server data by  sending request with acceptable user cookies. Clients can only get user cookies by calling the `Login` with user name and password.
* The client API form server does not need cache to get it working, you can get everyting you need form the server response. Cache is recommend for better user experience to preload when the internet is jammed or blocked.
* Client does not need to do any additional security process for server request or response data. That means you don't need to remove unexpected scripts or code from server or remove them before send to the server.
* Most of the rich-context is HTML format, you have to use a webbrowser component or parse it on your own.
* Contacts contains avatar for quick identification. It may be a Data URL like `data:image/gif;base64,/9j/...`
* For security reason, you *MUST* use HTTP with secure socket layer to get access to the server (like https://www.shisoft.net/ajax/Login). Any insecure HTTP request will redirect to HTTPS with the same address.
* For security reason, you *MUST* use POST method. Any other method will be ignored.
* Cookie should be delivered in any request after user logged in. Store user cookies for next startup will keep user online without authorization.

To Linux users: You may attempt build it using latest GNUstep and clang, but as of now, no success can be guaranteed.
