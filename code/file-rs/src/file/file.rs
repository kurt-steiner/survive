pub(crate) struct DirectoryEntry {
    pub(crate) filename: String,
    pub(crate) fcb: FileControlBlock
}

#[derive(Clone, Copy)]
pub(crate) struct FileControlBlock {
    pub(crate) size: u64,
    pub(crate) is_directory: bool,
    pub(crate) is_file: bool,
    pub(crate) is_block: bool,
    pub(crate) is_symlink: bool,
    pub(crate) is_hidden: bool,

    pub(crate) index_start_block: usize
}
