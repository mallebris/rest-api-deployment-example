# local test code

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
        "ABN AMRO": ["ABN", "AMRO"],
        "ING Bank": ["ING"],
        "Rabobank": ["Rabo"],
        "Triodos Bank":["Triodos"],
        "de Volksbank": ["de", "Volksbank"]}
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
    split_string = message.split(" ")
    logging.debug(f"Message words: {split_string}")
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

def main():
    logging.basicConfig(
        format="%(asctime)s %(levelname)s:%(message)s",
        datefmt="%m/%d/%Y:%I:%M:%S:%p",
        level=logging.DEBUG,
    )
    message = "The analysts of amro did a great job!"
    string_transformation(message)

if __name__ == "__main__":
    main()