
# #DownloadTheAds - yt-ad-dl
## 

<div align="center">

</div>


<i><div align="center">
<b>### WARNING: THIS SCRIPT IS A PROTOTYPE! ###<br>## THERE IS MUCH MORE WORK TO BE DONE! ##</b><br>
! This script is designed to work on GNU/Linux systems !<br>
(It might also work in WSL, but I haven't tested that.)
</div></i>
Shortcuts:

* [Intro](#the-mission)
* [usage](#usage)
* [examples](#examples)

# The Mission
## We are on a mission...
### A mission to audit a certain video site's advertisements...<br>
#### And all we need for this mission...<br>
### Is moar ads downloaded, and analysed.
That's right. We download them, and record the context regarding their placement.

The goals of this project is to function as the following:
> *Becoming a peace-worthy meme*<br>
> *Function as a peaceful protest against a certain video site's:*<br>
> - *broken anti-adblock policy*<br>
> - *lack of advertising standards*<br>
> - *frivolous greed*<br>

The second last point being the most important one. The creator of this repository has understanding (and personal experience) of the many hazards that unregulated online advertising can create.
These hazards include, but are not limited to:
>- Disability related hazards (photosensitive epilepsy, sensory overload, etc... *This is a serious accessibility issue*)
>- Mental health related hazards (PTSD triggers, among other things. *This is another accessibility issue*)
>- Inappropriate (and often illegal) advertisements (Showing alcohol, tobacco, and prescription drug ads in countries that ban such ads, showing cropped porno ads, ads containing Elsagate-esque footage and other content-farmed brain rot preying upon kids, etcetera. *These ads are most definitely illegal in some countries*)
>- Nuisance advertising practices (30 second unskippable ads, 8 hour ads, ads interrupting the video, multiple ads in a row, etc... *No wonder people are using ad blockers!*)
>- Invasive data collection (These mofos won't rest until they know my relationship status, sexual orientation, employment status, the durability level of my teeth, and when and where I take a shit! (and the contents of said fecal matter as well). They will happily sell that data off to others as well. Not only is this creepy, *this can be illegal under many situations. COPPA and GDPR, anyone?*)
>- False or misleading advertising (fake mobile game ads, bait-and-switch advertising, "FREE ROBUX", "PLAY MARIO MAKER ON MOBILE NOW", etc... *These ads are most definitely illegal in many countries, some of these ads infringe copyright laws for pete's sake!*)
>- Hate speech and objectionable ad placements (Organisations like PragerU, Matt Walsh, Heritage Foundation, etc. have been abusing targeted ads in order to target racist/homophobic/transphobic ads towards marganilised demographics. *These ads are probably illegal in some countries*)
>- Election interference, and fake news (Donald Trump and the sad case of Cambridge Analytica, Russian bot farms, etc... if you've got the money, you got the ad placement.)
>- SCAMS ("Mr Beast is giving away $1,000 to anyone who clicks this ad", "Play this mobile game and earn FREE MONEY", etc... *These ads are most definitely illegal in many countries*)
>- MALWARE via MALVERTISING (These kinds of malicious ads have appeared on Google searches for OBS, VLC, 7-Zip, CCleaner, Rufus, Notepad++, Blender, VirtualBox, Putty, etc, and don't even get me started on the ads that contain malicious Javascript code that compromises systems without even clicking on them. Any random jackoff can pay for ad placement, if they have enough money of course. The advertising platform may remove these ads days, months, or years after it's already too late. If you've gotten a virus in the last 10 years, there's a good chance it probably came from an ad. *These ads are most definitely illegal in most countries*. [Wikipedia](https://en.wikipedia.org/wiki/Malvertising), sources: [1](https://www.bleepingcomputer.com/news/security/hackers-push-malware-via-google-search-ads-for-vlc-7-zip-ccleaner/), [2](https://www.bleepingcomputer.com/news/security/hackers-push-malware-via-google-search-ads-for-vlc-7-zip-ccleaner/), [3](https://www.malwarebytes.com/blog/threat-intelligence/2022/07/google-ads-lead-to-major-malvertising-campaign)...
>>- The NSA, FBI, and CIA use (and even recommend the use of) ad blockers because of this, ROTFFLMFAO! sources: [1](https://www.vice.com/en/article/93ypke/the-nsa-and-cia-use-ad-blockers-because-online-advertising-is-so-dangerous), [2](https://www.wired.com/story/security-roundup-even-cia-nsa-use-ad-blockers/), [3](https://www.standard.co.uk/news/tech/fbi-recommends-ad-blocker-online-scams-b1048998.html), [4](https://interestingengineering.com/culture/cia-and-nsa-use-ad-blockers-to-stay-safe))

There isn't much of a choice of which ads are randomly shoved in YOU'RE FACE without consent, especially when they are highly offensive to the demographic they are targeted at (I'm looking at you, Matt Walsh!).

Also, [If the fucking CIA is blocking you're ads](https://www.vice.com/en/article/93ypke/the-nsa-and-cia-use-ad-blockers-because-online-advertising-is-so-dangerous), you know the online advertising industry is absolutely disgusting.

We need a method of gathering evidence of what ads they are showing, in order to report them for this kind of behaviour. Only then can we take them to court for carelessly facilitating the broadcasting of illegal advertisements, OwO.

So instead of downloading the videos (YT's anti-adblock doesn't prevent downloading videos, LOL!), why not download the ads themselves, and record what video it was shown on? This should give us a grasp as to how these ads are targeted, as well as the content of said ads. A form of forensic analysis, if you will...

The goal isn't to download the videos themselves. We just want to download the ads that are placed on them. We then record metadata about the video along with the ad and append it into a log file. That way, we can see which ad appeared on which video, along with the context of the video, and a timestamp of when the video was analysed for ad placements.

Also, to keep with the spirit of YT-DLP, this software will be licensed under the Unlicense, so do with it as you please. OwO...

# USAGE
#### The YT-AD-DL script is executed as so:
$ `./yt-ad-dl.sh https://www.youtube.com/watch?v=VIDEOID`
or
$ `./yt-ad-dl.sh https://vid.frontend.invalid/watch?v=VIDEOID`

This should be conpatible with YT video URLs, as well as the many alternative frontends with compatible URL formats (Invidious, Piped, etc...).
The script grabs the VIDEOID from the URL, and assembles a proper YT url for the purposes of compatibility with these alternative frontends.
Plain 'https://www.youtube.com/watch?v=VIDEOID' video URLS will also work (but not the shortened 'youtu.be' ones, sadly...)

The script will record a timestamp, and get the metadata of the video, namely the URL, uploader, and title.

Then it will look for ads. If found, each ad is processed as follows:
* YT-hosted ads: If an ad is found, it will retrieve the video page of it's YT video page, and parse it's metadata (URL, uploader, and title). It will then fetch the video ad itself using yt-dlp, and log this occurance into the log file.

__TODO: Implement processing of other ad types, including midroll and end ads.__

Once an ad is processed, a timestamp, the metadata about the video ad and the metadata of the video it was placed on, is appended to the ./yt-ad-dl.log file in JSON format as described below:

`{ TIMESTAMP:"<TIMESTAMP>", VID-UPLOADER:"<VIDEO uploader>", VID-URL:"<VIDEO URL>?", VID-TITLE:"<VIDEO title>", ADTYPE:"<AD type>", AD-UPLOADER:"<AD uploader name>", AD-URL:"<ad URL>", AD-TITLE="<video title>", AD-FILE="<downloaded ad video file>" },`

This log file is placed in the current directory, so you might want to execute this script from within a dedicated folder (or by copying the yt-ad-dl.sh script into said folder).

##### Variable Description
* Video metadata (useful for context of ad placements)
* > TIMESTAMP: The timestamp from when the video URL was requested, with timezone. Timezone may provide a rough (but not very accurate) estimate of the country the ad was broadcasted in.
* > VID-UPLOADER: The user who uploaded the video
* > VID-URL: The URL of the video in question.
* > VID-TITLE: The user who uploaded the video
* AD context (Information about the ad itself)
* > AD-TYPE: the type of ad. This indicates the hosting system the ad uses.
* > AD-UPLOADER: The account that uploaded the ad. A.K.A. Who to blame for the posting of said ad
* > AD-URL: The URL of said ad
* > AD-TITLE: The title of the ad
* > AD-FILE: The filename of the ad, downloaded into the current directory.

If there are no ads on the video, nothing will be logged.
 
Both the log file, and the downloaded ads, are assumed to be dumped into the current directory. So again, use a dedicated folder to execute this script in. Copy it in there if necessary.

The geographic origin of the output log can be estimated based on the AD-UPLOADER and AD-TITLE of the ads observed (as well as the timezone in TIMESTAMP if it matches up to the ads)

# Examples
Example outputs can be found in the *EXAMPLES.md* file. These are real ones I came across in my testing, hand-picked to the ones I thought were funny or ridiculous. Testing was done in New Zealand without a VPN or proxy, and the timezone (and the ads themselves) reflect that fact.
