# Warframe clan util
A simple tool help you extract useful information about your clan.

## Disclaimer
This project is not affiliated with Digital Extremes Ltd.
Warframe is a registered trademark of Digital Extremes Ltd.

This software breaches the Warframe [terms of use](https://www.warframe.com/terms).

## Data
This tool can help you obtain data such as:
- Clan ID (this field is not always accessible)
- Clan Name
- Members List
    - In game names
    - Date joined
    - Contributions
    - Rank
    - etc.
- Ranks
- Tier
- Contributions
- Research

## Requirements:
- 64 bit windows machine only
- Powershell 5.1

## Installation
- Download and unzip in a directory with at least 4 GB of disk available
- Execute the `setup.cmd` batch file. This will install dependencies and open your powershell execution policy.

## Usage
- Start Warframe
- Login
- Leave you warframe in your orbiter outside of any menu
- Run the `dumpClan.cmd` batch file. This might take a minute. An text file will open once complete.

The script will switch back to the warframe client and navigate to the clan menu. The warframe client might freeze for a few seconds as the proccess memory is being dumped to disk. This process might be repeated a few times if no data is found on the first try.

The dump file is available in  the `dumps/` directory.
The json file opened at the end of the script can be found in the `output/` directory.
