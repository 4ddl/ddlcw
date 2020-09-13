from ddlcw import Runner
from ddlcw.languages import c_lang_config, java_lang_config, kotlin_lang_config
import json
import os
from ddlcw.config import DEBUG


def main(test_case_dir, manifest_param, code_param, config):
    print('DEBUG ', DEBUG)
    runner = Runner(test_case_dir, manifest_param,
                    1000, 96, code_param, config)
    print(runner.compile())
    print(runner.run())


if __name__ == '__main__':
    manifest = {
        "hash": "1892378192372127389137",
        'test_cases': [{'in': '1.in', 'out': '1.out'}, {'in': '2.in', 'out': '2.out'}],
        'spj': True,
        'spj_code': ''
    }
    with open('./1/spj.c', 'r') as f:
        manifest['spj_code'] = f.read()
    # with open('./1/test.c', 'r') as f:
    #     code = f.read()
    # main('/test_cases', manifest, code, c_lang_config)
    # with open('./1/Main.java', 'r') as f:
    #     code = f.read()
    # main('/test_cases', manifest, code, java_lang_config)
    with open('./1/main.kt', 'r') as f:
        code = f.read()
    main('/test_cases', manifest, code, kotlin_lang_config)
