# Udacity - Blockchain Developer Nanodegree Program

## Project 3 - Ethereum Dapp for Tracking Items through Supply Chain

### Project Details

For this project, you will creating a DApp supply chain solution backed by the Ethereum platform.

You will architect smart contracts that manage specific user permission controls as well as contracts that track and
verify a product’s authenticity.

### 1. Part 1 - Plan the project with write-ups

#### A) Requirement 1 - Project write-up - UML

##### Planning Overview

| Supply chain |
|:---:|
|French bread|

| Assets |
|:---:|
|wheat|
|baguette|

| Actor | Role |
|:---:|:---:|
|Farmer|can harvest wheat|
|Farmer|can process wheat into baguette|
|Farmer|can pack the baguette|
|Farmer|can mark the baguette for sale|
|Distributor|can buy the baguette|
|Distributor|can ship the baguette|
|Retailer|can receive the baguette|
|Consumer|can purchase the baguette|

##### Activity Diagram

![baguette-activity-diagram](res/baguette-activity-diagram.png)

##### Sequence Diagram

![baguette-sequence-diagram](res/baguette-sequence-diagram.png)

##### State Diagram

##### Data Modelling

#### B) Requirement 2 - Project write-up - Libraries

If libraries are used in the project, the project write-up indicates which libraries and discusses why these libraries
were adopted.

| Libraries used | Version | Motivation |
|:---:|:---:|:---:|
|web3.min.js|0.19.0|To allow interaction with ethereum contracts from browser|
|truffle-contract.js|0.5.5|To allow interaction with ethereum contracts from browser|
|jquery-3.6.0.min.js|3.6.0|To build very simple front-end (the focus of the project are the contracts)|

#### C) Requirement 3 - Project write-up - IPFS

If IPFS is used, the project write-up discusses how IPFS is used in this project.

| Libraries used | Version | Motivation |
|:---:|:---:|:---:|
|IPFS not used|N/A|N/A|

### 2. Part 2	Write smart contracts

### 3. Part 3	Test smart contract code coverage

### 4. Part 4	Deploy smart contracts on a public test network (Rinkeby)

### 5. Part 5	Modify client code to interact with smart contracts
