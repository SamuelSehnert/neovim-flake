{
    #writeIf = { c, v1, v2 ? "" }: if c then v1 else "";
    writeIf = boolean: dataOut: if boolean then dataOut else "";
}
