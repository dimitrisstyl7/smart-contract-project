// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

/**
 * @title SmartVote Contract
 * @notice This contract allows the creation of new polls, participation in polls, and viewing of results.
 * @dev Users can create polls, vote on them, close them, and view poll results.
 */
contract SmartVote {
    
    /**
     * @notice Represents a poll with a question, creator's address, open status, vote mapping, and positive/negative vote counters.
     */
    struct Poll {
        string question;                // The question for the poll
        address creatorAddress;         // The address of the poll creator
        bool isOpen;                    // The status indicating if the poll is open for voting
        mapping(address => bool) votes; // Mapping to track votes (true for voted, false for not voted)
        uint numOfPositiveVotes;        // The number of positive (true) votes received
        uint numOfNegativeVotes;        // The number of negative (false) votes received
    }

    Poll[] private polls;   // Array to store all the polls

    /**
     * @notice Creates a new poll with the given question.
     * @dev Adds a new Poll struct to the polls array.
     * @param question The question for the new poll.
     */
    function createNewPoll(string calldata question) external {
        Poll storage poll = polls.push();   // Add a new Poll and get a reference to it
        poll.question = question;           // Set the poll's question to the given question
        poll.creatorAddress = msg.sender;   // Set creatorAddress to the caller's address
        poll.isOpen = true;                 // Set isOpen to true
    }

    /**
     * @notice Allows a user to cast their vote in a specific poll.
     * @dev Records the user's vote for the specified poll.
     * @param poll_id The id of the poll in which the user is voting.
     * @param vote The vote (true/false) the user is casting.
     */
    function castVote(uint poll_id, bool vote) external {
        require(poll_id < polls.length, "Invalid poll id"); // Check if poll_id is within valid range

        Poll storage poll = polls[poll_id];                 // Get a reference to the selected poll
        require(poll.isOpen, "Poll is closed");             // Check if the poll is open for voting

        address userAddress = msg.sender;
        require(!poll.votes[userAddress], "Already voted"); // Check if the user has not already voted
        poll.votes[userAddress] = vote;                     // Record the user's vote

        // Increment the vote counters based on the vote value
        if (vote) {
            poll.numOfPositiveVotes++;
        } else {
            poll.numOfNegativeVotes++;
        }
    }

    /**
     * @notice Closes a specific poll, preventing any further votes from being cast.
     * @dev Sets the isOpen status of the specified poll to false, ensuring it cannot be voted on.
     * @param poll_id The id of the poll to close.
     */
    function closePoll(uint poll_id) external {
        require(poll_id < polls.length, "Invalid poll id"); // Check if poll_id is within valid range
        Poll storage poll = polls[poll_id];                 // Get a reference to the selected poll
        poll.isOpen = false;                                // Set isOpen to false
    }

    /**
     * @notice Returns the number of positive and negative votes for a specific poll.
     * @dev Retrieves the vote counts for the specified poll and returns them.
     * @param poll_id The id of the poll whose votes are being queried.
     * @return numOfPositiveVotes The number of positive votes for the poll.
     * @return numOfNegativeVotes The number of negative votes for the poll.
     */
    function showPollVotes(uint poll_id) external view returns (uint numOfPositiveVotes, uint numOfNegativeVotes) {
        require(poll_id < polls.length, "Invalid poll id");         // Check if poll_id is within valid range
        Poll storage poll = polls[poll_id];                         // Get a reference to the selected poll
        return(poll.numOfPositiveVotes, poll.numOfNegativeVotes);   // Return vote counts for positive and negative votes
    }

}