# Thirdle
A multiplayer wordle game that you can play with your friends while speaking to them over a video call.

https://user-images.githubusercontent.com/62273306/219611332-f7e3a5b4-77e0-42b1-8d14-b4f9f3b41105.mp4

Here's a video series on ["How to build Thirdle"](https://youtube.com/playlist?list=PLqHX7Ti3L8isxZWw_oE3V4P5n8BPnKQLe) step-by-step.

## What is special?

A video call while playing Wordle can’t be called a multiplayer game right? We wanted to share the players’ guess words on every new guess they make.

We did it seamlessly without needing a backend (Firebase, etc), but instead using "Peer Metadata" built into the 100ms SDK.

<img src="https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99" alt="Star Badge"/>

Built with 💙 using [Flutter](https://flutter.dev/) and [100ms SDK](https://www.100ms.live/).  

## Trying it out

Clone the repo and build it with `flutter` commands.

You need 3 things to start playing Thirdle with your own 100ms account (or use the default values if you don't have one)
1. Name - This will be your display name
2. Room Id - Your 100ms room Identifier
3. Subdomain - The subdomain from your 100ms token endpoint

### Room Id
Go to your 100ms Dashboard > Rooms section, copy an existing room's `Room Id` or create a new room and copy its `Room Id`.

### Subdomain
Go to your 100ms Dashboard > Developer section. Find your subdomain in token endpoint.
If your token endpoint is `https://prod-in2.100ms.live/hmsapi/example.app.100ms.live/`, then `example` is your subdomain.

## Team

<table>
  <tr>
<td align="center"><a href="https://github.com/coder-with-a-bushido"><img src="https://avatars.githubusercontent.com/u/62273306?v=4" width="100px;" alt=""/><br /><sub><b>Karthikeyan S</b></sub></a></td>
<td align="center"><a href="https://github.com/adityathakurxd"><img src="https://avatars.githubusercontent.com/u/53579386?v=4" width="100px;" alt=""/><br /><sub><b>Aditya Thakur</b></sub></a></td>
  </tr>
</table>

