# Definitions:
# Input unnormalized string where the pattern should be found
# The modification of strings should be related to the found numbers everything else left as is
# Returns:
# If there is no pattern found returns origin input
# there is no any special requirement about input string few constrains in place:
# - only the first occurance replaced
# - this is not a string 

# • ABN -> ABN AMRO
# • ING -> ING Bank
# • Rabo -> Rabobank
# • Triodos -> Triodos Bank
# • Volksbank -> de Volksbank

import re
import logging

def reg_exp_process(search_pattern, replace_string, message):
    re_pattern = re.compile(search_pattern, flags=re.IGNORECASE)
    regexp_result = re_pattern.search(message)
    if regexp_result != None:
            logging.debug(f"Found match patterm: {regexp_result.group()}")
            result = re.sub(search_pattern, replace_string, message, flags=re.IGNORECASE)
            logging.debug(f"Modified string: {result}")
            return result
    return None

def string_transformation(message):
    desired_strings = {
        "ABN AMRO": [r'\bABN\b', r"\bAMRO\b"],
        "ING Bank": [r'\bING\b'],
        "Rabobank": [r"\bRabo\b"],
        "Triodos Bank":[r"\bTriodos\b"],
        "de Volksbank": [r"\bde\b", r"\bVolksbank\b"]}
    logging.debug(f"Origin message: {message}")
    
    # covering basic cases O(n)
    for pattern in desired_strings:
        if pattern in message:
            logging.debug(f"No Changes required")
            return message
        else:
            result = reg_exp_process(search_pattern=pattern,replace_string=pattern, message=message)
            if result != None:
                return result
    # covering search cases, O(n^2)
    for target, parts in desired_strings.items():
        logging.info(f"desired string {target}")
        logging.info(f"Searching for parts {parts}")
        for item in parts:
            result = reg_exp_process(search_pattern=item,replace_string=target, message=message)
            if result != None:
                return result
    logging.info("Patterns not found, returning origin message")
    return message

def lambda_handler(event, context):
    logging.basicConfig(
        format="%(asctime)s %(levelname)s:%(message)s",
        datefmt="%m/%d/%Y:%I:%M:%S:%p",
        level=logging.DEBUG,
    )
    return string_transformation(event['message'])