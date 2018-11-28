(use '[clojure.string :only (join)])

(defn register? [value]
  (and (symbol? value)
       (.startsWith (str value) "%")))

(defn reg->str
  "Convert an x86-64 register from its Clojure form (a keyword) to a string."
  [reg] (str reg))

(defn operand->str
  "Convert an x86-64 instruction operand from its Clojure form to a string."
  [arg]
  (cond
    (integer? arg) (str "$" arg)
    (register? arg) (reg->str arg)
    (symbol? arg) (str arg)
    (vector? arg) (if (and (= (count arg) 2)
                           (or (integer? (first arg))
                               (symbol? (first arg))))
                    (str (first arg) "(" (operand->str (second arg)) ")")
                    (str "(" (join ", " (map operand->str arg)) ")"))))

(defn insn->str
  "Convert one x86-64 instruction from its Clojure list form to a string,
  one line of assembly."
  [insn] (let [name (first insn)
               args (rest insn)]
           (str "\t" name "\t" (join ", " (map operand->str args)))))

;; Assembly files are not just instructions.
;; They also contain "directives" to tell the assembler what to do with the instructions.
;; These functions emit directives.
(def directive-formatters
  {'.section #(join "," %&)
   '.label #(str %1 ":")
   '.asciz #(pr-str %1)
   })

(defn default-format [& args]
  (join ", " (map str args)))

(defn directive->str
  "Convert an assembler directive from its Clojure list form to a string."
  [source]
  (let [command (first source)
        args (rest source)]
    (if (= command '.label)
      (str (first args) ":")
      (str "\t" command "\t"
           (apply (directive-formatters command default-format) args)))))

(defn split-comment
  "We support comments by letting the user add `:# \"string\"` at the end of any list.
  This function strips the comment, if any, from the given `source` list.
  Returns a vector, [uncommented-line comment-or-nil]."
  [commented-line]
  (let [n (count commented-line)]
    (if (and (>= n 2)
             (= (nth commented-line (- n 2)) :#))
      (vector (take (- n 2) commented-line) (last commented-line))
      (vector commented-line nil))))

(defn directive? [line]
  (.startsWith (str (first line)) "."))

(defn emit-comment [comment]
  (if (nil? comment)
    ""
    (str "\t## " comment)))

(defn line->str [commented-line]
  (let [[line comment] (split-comment commented-line)
        code-line (cond
                    (nil? line) ""
                    (directive? line) (directive->str line)
                    :else (insn->str line))]
    (str code-line (emit-comment comment) "\n")))

(let [program (binding [*read-eval* false] (read))
      lines (map line->str program)
      output (join lines)]
  (print output))
