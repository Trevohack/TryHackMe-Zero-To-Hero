
// FUZZ script writen by Trevohack 
// node fuzzer.js http://trevohack.com/ATTACK /usr/share/words.txt parallel 
// node fuzzer.js http://trevohack.com/ATTACK /usr/share/words.txt sequential 


const fs = require('fs').promises;
const axios = require('axios');

async function fuzzWithWordlist(baseURL, wordlistPath, mode) {
    try {
        const data = await fs.readFile(wordlistPath, 'utf-8');
        const words = data.split('\n');

        if (mode === 'parallel') {
            console.log("Using parallel fuzzing...");
            await parallelFuzzing(baseURL, words);
        } else if (mode === 'sequential') {
            console.log("Using sequential fuzzing...");
            await sequentialFuzzing(baseURL, words);
        } else {
            console.error("Invalid mode. Please choose either 'parallel' or 'sequential'.");
        }

    } catch (error) {
        console.error(`[-] Error reading wordlist file: ${error.message}`);
    }
}

async function sequentialFuzzing(baseURL, words) {
    for (const word of words) {
        try {
            const url = baseURL.replace("ATTACK", word);
            const response = await axios.get(url);
            if (response.status === 200) {
                console.log(`[+] Success: ${url} - Status: ${response.status}`);
            }
        } catch (error) {
        }
    }
}

async function parallelFuzzing(baseURL, words) {
    const concurrency = 1000;
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
}

const args = process.argv.slice(2);
if (args.length !== 3) {
    console.error("Usage: node fuzzer.js <url> <wordlist> <mode>");
    console.error("Mode: 'parallel' or 'sequential'");
    process.exit(1);
}

const baseURL = args[0];
const wordlistPath = args[1];
const mode = args[2];

fuzzWithWordlist(baseURL, wordlistPath, mode);
