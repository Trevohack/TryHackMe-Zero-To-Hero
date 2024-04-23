
// FUZZ script writen by Trevohack 
// node fuzzer.js http://trevohack.com/ATTACK /usr/share/words.txt

const fs = require('fs').promises;
const axios = require('axios');

async function fuzzWithWordlist(baseURL, wordlistPath) {
    try {
        const data = await fs.readFile(wordlistPath, 'utf-8');
        const words = data.split('\n');

        const concurrency = 100;

        await Promise.all(words.map(async word => {
            try {
                const url = baseURL.replace("ATTACK", word);
                const response = await axios.get(url);
                if (response.status === 200) {
                    console.log(`[+] Success: ${url} - Status: ${response.status}`);
                }
            } catch (error) {
            }
        }));

    } catch (error) {
        console.error(`[-] Error reading wordlist file: ${error.message}`);
    }
}

const args = process.argv.slice(2);
if (args.length !== 2) {
    console.error("Usage: node fuzzer_2.js <url> <wordlist>");
    process.exit(1);
}

const baseURL = args[0];
const wordlistPath = args[1];

fuzzWithWordlist(baseURL, wordlistPath);
