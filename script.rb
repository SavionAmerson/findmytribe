require ('watir')
require 'JSON'
file = File.open "creds.json"
data = JSON.load file

browser = Watir::Browser.new:chrome, options: {options: {detach: true}}

profiles = []
profilesToPop = []
likebuttonxpath = browser.element(:xpath => "(/html/body/div/div/div/div/div/div/div/div/div/div/div/div/div/div/ul/li/button)[1]") #number of likes button
divexitxpath = browser.element(:xpath => "(/html/body/div[4]/div/div/button)") #xpath for the div exit button
reactionNumber = browser.element(:xpath => "(/html/body/div[4]/div/div/div[1]/div/artdeco-tabs/artdeco-spotlight-tablist/artdeco-spotlight-tab[1]/span[2])") #number of reactions
profilelinks = browser.element(:xpath => "(/html/body/div[4]/div/div/div[2]/div/ul/li[1]/a)") #links of profiles
connectionNumber = browser.element(:xpath => "(/html/body/div[5]/div[4]/div[3]/div/div/div/div/div/div/div/div/section/header/h1)") #number of connected profiles
connectionType = browser.element(:xpath => "(/html/body/div[4]/div/div/div[2]/div/ul/li[1]/a/div[2]/h3/span[2]/span[2])") #tells if connection is 1st degree or not




browser.goto 'linkedin.com/login'
browser.send_keys data["email"], :tab
browser.send_keys data["password"], :return
browser.goto 'https://www.linkedin.com/in/fritzops/detail/recent-activity/shares/'
browser.wait(timeout = 3)
browser.send_keys :page_down, :page_down, :page_down
browser.send_keys :page_up, :page_up, :page_up
browser.wait(timeout = 3)



gl = 0
while gl < 3
    gl+=1
    browser.element(:xpath => "(/html/body/div/div/div/div/div/div/div/div/div/div/div/div/div/div/ul/li[1]/button)[#{gl}]").send_keys :enter
    browser.wait(timeout = 3)
    browser.send_keys [:shift, :tab]
    divexitxpath
    browser.send_keys :tab, :tab
    nn = 0
    while nn < reactionNumber.text.to_i
        nn+=1
        browser.send_keys :tab
    end


    rni1 = reactionNumber.text.to_i
    n = 0
    while n < rni1
        n+=1
        connectionType = browser.element(:xpath => "(/html/body/div[4]/div/div/div[2]/div/ul/li[1]/a/div[2]/h3/span[2]/span[2])").text.to_i
        if connectionType != 1 
            profiles.push(browser.element(:xpath => "(/html/body/div[4]/div/div/div[2]/div/ul/li[#{n}]/a)").parent.a.href(&:text).gsub(/\?.*/, ""))
            if n == rni1
                browser.send_keys :escape
            end
        end
    end
    browser.send_keys :escape
end


profiles = profiles.uniq


browser.goto 'https://www.linkedin.com/mynetwork/invitation-manager/sent/'
browser.wait(timeout = 3)


noipv = 0
numOfInvitedProfiles = browser.element(:xpath => "(//*[@id='mn-invitation-manager__invitation-facet-pills--CONNECTION']/span)").text.to_s.slice(8).to_i

while noipv < numOfInvitedProfiles
noipv+=1
    profilesToPop.push(browser.element(:xpath => "(/html/body/div[6]/div[4]/div[3]/div/div/div/div/div/div/section/div/div[2]/ul/li[#{noipv}]/div/div[2]/div/a)").parent.a.href(&:text))
end

profilesToPop.push("https://www.linkedin.com/in/nicole-gaehle")





popAmt = profilesToPop.length
popCounter = 0

while popCounter < popAmt
    newPC = profilesToPop[popCounter]
    profiles = profiles - %W{"#{newPC}"}
    popCounter += 1
end




targetAmnt = profiles.length
targetCounter = 0

while targetCounter < targetAmnt
    linkStr = profiles[targetCounter]
    linkStrTwo = linkStr
    browser.goto linkStrTwo

    connectBTN = browser.element(:xpath => "(/html/body/div[6]/div[4]/div[3]/div/div/div/div/div[2]/main/div[1]/div/section/div[2]/div[1]/div[2]/div/div/span[1]/div/button)")
    if connectBTN.exists? 
        sleep 1 
        connectBTN.send_keys :enter
    end

    noteBTN = browser.element(:xpath => "(/html/body/div[4]/div/div/div[3]/button[1]/span)")
    if noteBTN.exists?
        sleep 1
        noteBTN.send_keys :enter
    end

    textArea = browser.element(:xpath => "(/html/body/div[4]/div/div/div[2]/div/textarea)")
    if textArea.exists?
        sleep 1
        textArea.send_keys "Thanks for engaging on my post! I made this video for you: https://youtu.be/Gqm4x07Bj8k

        And if you'd like to chat sometime, grab a spot at calendly.com/archdevops/linkedin-connection
        
        Hope we can be connected soon."
    end

    doneBTN = browser.element(:xpath => "(/html/body/div[4]/div/div/div[2]/div/textarea)")
    if doneBTN.exists?
        sleep 1
        doneBTN.send_keys :enter
    end

    targetCounter += 1
end

### SCRIPT DONE!