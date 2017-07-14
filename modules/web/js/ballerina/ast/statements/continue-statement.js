/**
 * Copyright (c) 2017, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
import _ from 'lodash';
import Statement from './statement';

/**
 * Class to represent an Continue statement.
 */
class ContinueStatement extends Statement {
    /**
     * Constructor for continue statement
     */
    constructor() {
        super();
        this.type = 'ContinueStatement';
        this.whiteSpace.defaultDescriptor.regions = {
            0: '',
            1: ' ',
            2: '\n',
            3: ' ',
        };
    }

    /**
     * Initialize the node from the node json.
     * @returns {void}
     * */
    initFromJson() {
    }

    /**
     * Get the statement string
     * @returns {string} break statement string
     * @override
     */
    getStatementString() {
        return 'continue';
    }
}

export default ContinueStatement;

