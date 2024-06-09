{
	// Place your global snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and 
	// description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope 
	// is left empty or omitted, the snippet gets applied to all languages. The prefix is what is 
	// used to trigger the snippet and the body will be expanded and inserted. Possible variables are: 
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. 
	// Placeholders with the same ids are connected.
	// Example:
	// "Print to console": {
	// 	"scope": "javascript,typescript",
	// 	"prefix": "log",
	// 	"body": [
	// 		"console.log('$1');",
	// 		"$2"
	// 	],
	// 	"description": "Log output to console"
	// }

	"Console Log": {
		"prefix": "clog",
		"body": [
			"console.log('${CLIPBOARD}',${CLIPBOARD})"
		],
		"description": "Output to console"
	},
	"Console Log Color": {
		"prefix": "clogc",
		"body": [
			"console.log('%c ${CLIPBOARD}','background: black; color: yellow', ${CLIPBOARD});"
			// console.log('%c SumCertificateFeesTotal ', 'background: black; color: yellow');
			// console.log('%c SumCertificateFeesTotal ', 'background: red; color: white');
			// console.log('%c SumCertificateFeesTotal ', 'background: orange; color: blue');
		],
		"description": "Output to console"
	},
	"React Fragment Component for CaseJacket": {
		"prefix": "rfcc",
		"body": [
			"import React from 'react';",
			"import {Container} from 'reactstrap';",
			"",
			"interface CaseCardProps {",
			"    title: string;",
			"    disabled: boolean;",
			"}",
			"",
			"const ${TM_FILENAME_BASE/(.*)/${1:/capitalize}/} = ({title, disabled}: ${TM_FILENAME_BASE/(.*)/${1:/capitalize}/}Props) => {",
			"    $1document.title = '${TM_FILENAME_BASE/(.*)/${1:/capitalize}/} | CaseJacket';",
			"    return (",
			"      <React.Fragment>",
			"        <div className='page-content'>",
			"        <Container fluid>",
			"            <div>",
			"                <h1>${TM_FILENAME_BASE/(.*)/${1:/capitalize}/}</h1>",
			"            </div>",
			"        </Container>",
			"        </div>",
			"      </React.Fragment>",
			"    );",
			"};",
			"",
			"export default ${TM_FILENAME_BASE/(.*)/${1:/capitalize}/};"
		],
		"description": "Create an empty React fragment component"
	},
	"TypeScript Map": {
		"prefix": "tsmap",
		"body": [
			" {${CLIPBOARD}.map((item, key) => (",
			"     <React.Fragment key={key}>",
			"         {item.guid}",
			"     </React.Fragment>",
			"   ))",
			" }",
		],
		"description": "TypeScript basic map function"
	}
}
