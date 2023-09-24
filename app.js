const co = require('co');
const request = require('co-request');
const cheerio = require('cheerio');
const _ = require('lodash');
const exec = require('child_process').exec;
const fs = require('fs');



const CHECK_INTERVAL_MS = 50000;
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

let cookieJar = request.jar();

let buildRequest =async function (uri, method) {
  console.log("start")
  console.log(uri)
  await sleep(5000);
  console.log("finish")
  return request({
    uri: uri,
    method: method,
    jar: cookieJar,
    headers: {
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
    }
  });
};

let loadurl_events = function () {

    let listofurls=[]
    const allFileContents = fs.readFileSync('event_urls.txt', 'utf-8');
    
    allFileContents.split(/\r?\n/).forEach(line =>  {
        listofurls.push(line);
    });
    console.log(listofurls);
    return listofurls;
};

let tickets_already_notified=[];

let availableTicket= function (url) {

  tickets_already_notified.push(url);
  exec('spd-say "I found a ticket for you" ') //PLAYING SOUNBD
  exec(`python automaticClick.py ${url}`); //OPENING THE PYTHON SCRIPT TO RUN SELENIUM
  process.exit(0);
}




let app = function () {
  let events=loadurl_events();


  return co(function* () {
    console.log()
    
    for (var EVENT_URL of events){



      let result = yield buildRequest(EVENT_URL, 'GET');
      let $ = cheerio.load(result.body);

          let datalisting=$('a[data-testid=listing]');
          if(datalisting != null){
          datalisting.children().each((index,data) => {
          let urlticket=data['parent'].attribs['href']
            console.log("Calling the URL for the ticket")
            availableTicket(urlticket,"TEST");
      
        });
    }
    }

  }).catch(ex => {
    console.log(ex);
  });

};



app();
setInterval(app, CHECK_INTERVAL_MS);
