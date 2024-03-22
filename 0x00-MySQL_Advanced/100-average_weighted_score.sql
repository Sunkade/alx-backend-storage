-- SQL script to create a stored procedure to compute and store the average weighted score for a student

-- Drop the stored procedure if it already exists
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;

-- Delimiter change to handle semicolons within the procedure definition
DELIMITER $$

-- Create the stored procedure
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(
    IN user_id INT
)
BEGIN
    -- Declare variables to store the calculated weighted score and total weight
    DECLARE weighted_average DECIMAL(10, 2);
    DECLARE total_weight DECIMAL(10, 2);

    -- Calculate the total weighted score for the user
    SELECT SUM(score * weight) INTO weighted_average
    FROM assessments
    WHERE user_id = user_id;

    -- Calculate the total weight for the user
    SELECT SUM(weight) INTO total_weight
    FROM assessments
    WHERE user_id = user_id;

    -- Compute the average weighted score if total weight is not zero
    IF total_weight <> 0 THEN
        SET weighted_average = weighted_average / total_weight;
    ELSE
        SET weighted_average = 0;
    END IF;

    -- Insert or update the average weighted score for the user in a separate table (assuming 'user_scores' table)
    -- Change the table name accordingly
    INSERT INTO user_scores (user_id, average_weighted_score)
    VALUES (user_id, weighted_average)
    ON DUPLICATE KEY UPDATE
    average_weighted_score = VALUES(average_weighted_score);
END$$

-- Reset the delimiter to semicolon
DELIMITER ;
|
