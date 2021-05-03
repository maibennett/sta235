---
title: Week 14
weight: 80
disableToc: true
---

## Date: 05/03/2021

## What we will cover

In our last class, we will look at some other types of data (e.g. text), how to gather and analyze it, to motivate future endeavours. We will also bring everything together while we work through one big example!

## Task for this class

- Create a Twitter account and a Twitter development account.

**Instructions**

1) Log into your Twitter account (if you don't have one, create one at https://www.twitter.com)

2) Go to https://apps.twitter.com and "Create a new app". You will be promted to get a developer account.

3) Follow the instructions to submit your application for a developer account (Academic --> Student)

	*The main use for the use of the Twitter API is going to be educational. We will scrape tweets that contain hashtags from some trending topic and do sentiment analysis on that data. This means that we will categorize the different words of the tweets according to their sentiment.*

4) Once your developer account has been accepted, go back to https://apps.twitter.com and create a new project and a new app.

5) Once all of that is created, you will have an API and a Secret API key, in addition to different tokens. Copy and paste them into a note document or similar and store them in a secure place. We will use them in our R code when scraping data.

*You can follow this simple video I created to see how things should look like:*

{{< youtube src="https://www.youtube.com/embed/5KwPGzlvYBE" >}}


## JITT 

Complete before **Sunday May 2nd (11:59 pm)**. You can find the assignment <a onclick="ga('send', 'event', 'External-Link','click','JITT11','0','Link');" href="https://forms.gle/HwbnpjNKFZVNb5iK6" target="_blank">here</a>

## Slides

{{% button href="https://sta235.netlify.app/Classes/Week14/1_twitter/sp2021_sta235_17_twitter.html" icon="fas fa-external-link-alt" icon-position="right" %}}New window{{% /button %}} {{% button href="https://sta235.netlify.app/Classes/Week14/1_twitter/sp2021_sta235_17_twitter.pdf" icon="fas fa-file-pdf" icon-position="right" %}}Download{{% /button %}} 

{{< slides src="https://sta235.netlify.app/Classes/Week14/1_twitter/sp2021_sta235_17_twitter.html" >}}

{{% button href="https://sta235.netlify.app/Classes/Week14/2_Wrapup/sp2021_sta235_18_wrapup.html" icon="fas fa-external-link-alt" icon-position="right" %}}New window{{% /button %}} {{% button href="https://sta235.netlify.app/Classes/Week14/2_Wrapup/sp2021_sta235_18_wrapup.pdf" icon="fas fa-file-pdf" icon-position="right" %}}Download{{% /button %}} 

{{< slides src="https://sta235.netlify.app/Classes/Week14/2_Wrapup/sp2021_sta235_18_wrapup.html" >}}

## Code

Here is the R code we will review in class, with some additional data and questions <a onclick="ga('send', 'event', 'External-Link','click','code14','0','Link');" href="https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week14/code/sp2021_sta235_17_twitter.R" target="_blank" class="btn btn-default">Download<i class="fas fa-code"></i></a>