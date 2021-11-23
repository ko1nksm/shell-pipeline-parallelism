function next_token() {
    if (getline != 0) return $0
    exit 1
}

function expected_token(token) {
    if ($0 == token) return
    exit 1
}

function object(keys) {
    if (next_token() == "}") return
    while (1) {
        key = $0
        next_token()
        expected_token(":")
        next_token()
        value(keys SEP key)
        if (next_token() == "}") return
        expected_token(",")
        next_token()
    }
}

function array(keys, idx) {
    if (next_token() == "]") return
    while (1) {
        value(keys SEP idx)
        if (next_token() == "]") return
        expected_token(",")
        next_token()
        idx++
    }
}

function value(keys) {
    if ($0 == "{") {
        walk(keys, "{")
        object(keys)
        walk(keys, "}")
    } else if ($0 == "[") {
        walk(keys, "[")
        array(keys, 0)
        walk(keys, "]")
    } else if ($0 == "}" || $0 == "]") {
        exit 1
    } else {
        node(keys, $0)
    }
}

BEGIN {
    if (SEP == "") SEP = "\t"
    next_token()
    value(ROOT)
}
