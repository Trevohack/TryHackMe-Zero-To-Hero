
// FUZZ script writen by Trevohack 
// node fuzzer.js http://trevohack.com/ATTACK /usr/share/words.txt

const fs = require('fs').promises;
const axios = require('axios');

async function fuzzWithWordlist(baseURL, wordlistPath) {
    try {
        const data = await fs.readFile(wordlistPath, 'utf-8');
        const words = data.split('\n');

        const concurrency = 500;

        const processBatch = async (start, end) => {
            const batch = words.slice(start, end);
            await Promise.all(batch.map(async word => {
                try {
                    const url = baseURL.replace("ATTACK", word);
                    const response = await axios.get(url);
                    if (response.status === 200) {
                        console.log(`[+] Success: ${url} - Status: ${response.status}`);
                    }
                } catch (error) {
                }
            }));
        };

        let start = 0;
        while (start < words.length) {
            const end = Math.min(start + concurrency, words.length);
            await processBatch(start, end);
            start = end;
        }

    } catch (error) {
        console.error(`[-] Error reading wordlist file: ${error.message}`);
    }
}


const args = process.argv.slice(2);
if (args.length !== 2) {
    console.error("Usage: node fuzzer.js <urk> <wordlist>");
    process.exit(1);
}

const baseURL = args[0];
const wordlistPath = args[1];

fuzzWithWordlist(baseURL, wordlistPath);
