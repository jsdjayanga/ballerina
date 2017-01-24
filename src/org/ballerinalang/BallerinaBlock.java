/*
 *  Copyright (c) 2017, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package org.ballerinalang;

import com.intellij.formatting.Alignment;
import com.intellij.formatting.Block;
import com.intellij.formatting.Indent;
import com.intellij.formatting.Spacing;
import com.intellij.formatting.SpacingBuilder;
import com.intellij.formatting.Wrap;
import com.intellij.lang.ASTNode;
import com.intellij.psi.TokenType;
import com.intellij.psi.codeStyle.CodeStyleSettings;
import com.intellij.psi.formatter.common.AbstractBlock;
import com.intellij.psi.tree.IElementType;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.List;

import static org.ballerinalang.psi.BallerinaTypes.*;

public class BallerinaBlock extends AbstractBlock {

    private SpacingBuilder spacingBuilder;

    @NotNull
    private final ASTNode myNode;
    @Nullable
    private final Alignment myAlignment;
    @Nullable
    private final Indent myIndent;
    @Nullable
    private final Wrap myWrap;
    @NotNull
    private final CodeStyleSettings mySettings;
    @NotNull
    private final SpacingBuilder mySpacingBuilder;
    @Nullable
    private List<Block> mySubBlocks;


    protected BallerinaBlock(@NotNull ASTNode node, @Nullable Alignment alignment, @Nullable Indent indent, @Nullable
            Wrap wrap, @NotNull CodeStyleSettings settings, SpacingBuilder spacingBuilder) {
        super(node, wrap, alignment);

        this.myNode = node;
        this.myAlignment = alignment;
        this.myIndent = indent;
        this.myWrap = wrap;
        this.mySettings = settings;
        this.mySpacingBuilder = spacingBuilder;
        this.spacingBuilder = spacingBuilder;
    }


    @Override
    protected List<Block> buildChildren() {
        List<Block> blocks = new ArrayList<Block>();
        ASTNode child = myNode.getFirstChildNode();
        IElementType parentElementType = myNode.getElementType();

        while (child != null) {
            IElementType childElementType = child.getElementType();
            if (childElementType != TokenType.WHITE_SPACE) {

                Indent indent = Indent.getNoneIndent();

                if (childElementType == SERVICE_BODY) {
                    indent = Indent.getSpaceIndent(4);
                } else if (childElementType == FUNCTION_BODY) {
                    indent = Indent.getSpaceIndent(4);
                } else if (childElementType == CONNECTOR_BODY) {
                    indent = Indent.getSpaceIndent(4);
                }


                if (parentElementType == IF_ELSE_STATEMENT) {
                    if (childElementType == IF_ELSE_IF_CLAUSE_BODY) {
                        indent = Indent.getSpaceIndent(4);
                    }
                }
                if (parentElementType == ELSE_CLAUSE) {
                    if (childElementType == IF_ELSE_IF_CLAUSE_BODY) {
                        indent = Indent.getSpaceIndent(2);
                    }
                }
                if (parentElementType == ELSE_IF_CLAUSE) {
                    if (childElementType == IF_ELSE_IF_CLAUSE_BODY) {
                        indent = Indent.getSpaceIndent(2);
                    }
                }

                Block block = new BallerinaBlock(
                        child,
                        Alignment.createAlignment(),
                        indent,
                        null,
                        mySettings,
                        spacingBuilder
                );
                blocks.add(block);
            }
            child = child.getTreeNext();
        }
        return blocks;
    }

    @Override
    public Indent getIndent() {
        return myIndent;
    }

    @Nullable
    @Override
    public Spacing getSpacing(@Nullable Block child1, @NotNull Block child2) {
        return spacingBuilder.getSpacing(this, child1, child2);
    }

    @Override
    public boolean isLeaf() {
        return myNode.getFirstChildNode() == null;
    }
}
